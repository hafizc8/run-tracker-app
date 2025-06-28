import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';

// --- Entry Point untuk Service ---
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  print("✅ Background Service: onStart. Initializing permanent sensor streams.");

  // --- State Utama Service ---
  bool isRecording = false; // Flag utama untuk mengontrol sesi perekaman
  bool isPaused = false;

  // --- State Sesi Perekaman ---
  int elapsedTimeInSeconds = 0;
  int stepsInSession = 0;
  int totalStepsAtStart = 0;
  int totalStepsAtPause = 0;
  double currentDistanceInMeters = 0.0;
  final List<LocationPoint> currentPath = [];
  Map<String, dynamic>? latestLocation;
  Timer? updateTimer;

  // =========================================================================
  // KUNCI #1: ARSITEKTUR SENSOR SELALU AKTIF
  // Stream diinisialisasi satu kali saja dan berjalan selama service hidup.
  // Ini mencegah error inisialisasi ulang.
  // =========================================================================

  // --- Listener Pedometer (Selalu Aktif) ---
  final pedometerStream = Pedometer.stepCountStream;
  pedometerStream.listen((StepCount event) {
    if (!isRecording || isPaused) {
      // Jika tidak merekam, cukup simpan state terakhir untuk perhitungan nanti
      totalStepsAtPause = event.steps;
      return;
    }

    // Jika baru saja resume dari pause
    if (totalStepsAtPause > 0) {
      int stepsDuringPause = event.steps - totalStepsAtPause;
      totalStepsAtStart += stepsDuringPause; // Tambahkan langkah saat pause ke offset
      totalStepsAtPause = 0; // Reset
    }

    stepsInSession = event.steps - totalStepsAtStart;
  }).onError((error) {
    print("⛔ Pedometer Stream Error: $error");
    // Anda bisa mengirim error ini ke UI jika perlu
    // service.invoke('error', {'source': 'pedometer', 'message': error.toString()});
  });

  // --- Listener Geolocator (Selalu Aktif) ---
  final positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 2, // Filter jarak 2 meter untuk efisiensi baterai
    ),
  );
  positionStream.listen((Position position) {
    if (!isRecording || isPaused) return; // Abaikan jika tidak merekam atau sedang pause

    final newPoint = LocationPoint(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp);

    if (currentPath.isNotEmpty) {
      final lastPoint = currentPath.last;
      double distance = Geolocator.distanceBetween(
        lastPoint.latitude, lastPoint.longitude,
        newPoint.latitude, newPoint.longitude,
      );
      
      if (distance > 0) {
        currentDistanceInMeters += distance;
      }
    }
    currentPath.add(newPoint);

    latestLocation = {
      "latitude": newPoint.latitude,
      "longitude": newPoint.longitude,
      "timestamp": newPoint.timestamp.toIso8601String(),
    };
  }).onError((error) {
    print("⛔ Geolocator Stream Error: $error");
  });

  // =========================================================================
  // LISTENER UNTUK PERINTAH DARI UI
  // =========================================================================

  service.on('startRecording').listen((event) {
    print("Background Service: ==> Event 'startRecording' received.");
    if (isRecording) {
      print("Warning: startRecording called, but a session is already active.");
      return;
    }
    // Reset semua state sesi
    elapsedTimeInSeconds = 0;
    stepsInSession = 0;
    currentDistanceInMeters = 0.0;
    currentPath.clear();
    isPaused = false;
    totalStepsAtPause = 0;
    
    // Ambil total langkah saat ini sebagai titik awal (offset)
    Pedometer.stepCountStream.first.then((value) => totalStepsAtStart = value.steps);

    isRecording = true;

    // Mulai Timer yang mengirim update ke UI & Notifikasi
    updateTimer?.cancel();
    updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRecording) {
        timer.cancel();
        return;
      }
      if (!isPaused) {
        elapsedTimeInSeconds++;
      }
      // Kirim update ke UI
      service.invoke('update', {
        "elapsedTime": elapsedTimeInSeconds,
        "steps": stepsInSession,
        "distance": currentDistanceInMeters,
        "location": latestLocation,
      });
      latestLocation = null;

      // Update notifikasi foreground
      final String content = "Time: ${NumberHelper().formatDuration(elapsedTimeInSeconds)}, Distance: ${NumberHelper().formatDistanceMeterToKm(currentDistanceInMeters)}";
      service.invoke(
        'update_notification',
        {
          "title": isPaused ? "Record Activity Paused" : "Record Activity Active",
          "content": content,
        },
      );
    });
  });

  service.on('stopRecording').listen((event) {
    print("Background Service: ==> Event 'stopRecording' received.");
    isRecording = false;
    isPaused = false;
    updateTimer?.cancel();
    // Kirim data final ke UI jika perlu
    service.invoke('final_update', { /* data final */ });
  });

  service.on('pause').listen((event) {
    print("Background Service: ==> Event 'pause' received.");
    if (!isPaused && isRecording) {
      isPaused = true;
    }
  });

  service.on('resume').listen((event) {
    print("Background Service: ==> Event 'resume' received.");
    if (isPaused && isRecording) {
      isPaused = false;
    }
  });
  
  service.on('stopService').listen((event) {
    print("⛔ Background Service: ==> Event 'stopService' received. Shutting down.");
    updateTimer?.cancel();
    // Tidak perlu membatalkan stream utama karena mereka terikat pada siklus hidup service
    service.stopSelf();
  });

  service.invoke('service_ready');
  print("✅ Background Service: All listeners are set up. Service is ready.");
}




// ✨ BARU: Buat fungsi wrapper khusus untuk background iOS
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // Anda bisa menambahkan logika spesifik iOS di sini jika perlu
  
  print('FLUTTER BACKGROUND SERVICE: Ios Background Invoked');

  // Tidak perlu memanggil onStart, karena service sudah dikonfigurasi
  // untuk menjalankan onStart saat di-launch. Fungsi ini hanya sebagai
  // entry point untuk background fetch yang harus mengembalikan bool.
  
  return true; // Memberitahu iOS bahwa tugas background fetch berhasil.
}