import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:pedometer_2/pedometer_2.dart';

// --- Entry Point untuk Service ---
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  _log(service, LogLevel.info,
      "onStart initiated. Initializing permanent sensor streams.");

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

  bool justResumed = false;

  // =========================================================================
  // KUNCI #1: ARSITEKTUR SENSOR SELALU AKTIF
  // Stream diinisialisasi satu kali saja dan berjalan selama service hidup.
  // Ini mencegah error inisialisasi ulang.
  // =========================================================================

  Pedometer().stepCountStream().listen((steps) {

    if (!isRecording || isPaused) {
      // Jika tidak merekam, cukup simpan state terakhir untuk perhitungan nanti
      totalStepsAtPause = steps;
      return;
    }

    _log(service, LogLevel.verbose, "Pedometer raw event: $steps steps.");

    // Jika baru saja resume dari pause
    if (totalStepsAtPause > 0) {
      int stepsDuringPause = steps - totalStepsAtPause;
      totalStepsAtStart += stepsDuringPause; // Tambahkan langkah saat pause ke offset
      totalStepsAtPause = 0; // Reset
    }

    stepsInSession = steps - totalStepsAtStart;
  }).onError((error) {
    _log(service, LogLevel.error, "Pedometer Stream Error", error);
    // Anda bisa mengirim error ini ke UI jika perlu
    // service.invoke('error', {'source': 'pedometer', 'message': error.toString()});
  });

  // --- Listener Geolocator (Selalu Aktif) ---
  final positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    ),
  );
  positionStream.listen((Position position) {
    if (!isRecording || isPaused) return; // Abaikan jika tidak merekam atau sedang pause

    final newPoint = LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );

    if (justResumed) {
      // Jika baru saja resume, jangan hitung jarak.
      // Cukup tambahkan titik baru sebagai titik awal untuk segmen rute berikutnya.
      _log(service, LogLevel.info, "Just resumed. Ignoring distance calculation for this point.");
      // Set flag kembali ke false agar perhitungan selanjutnya berjalan normal.
      justResumed = false;
    } else if (currentPath.isNotEmpty) {
      final lastPoint = currentPath.last;
      double distance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );

      _log(service, LogLevel.verbose, "Geolocator new position: lat=${position.latitude}, lon=${position.longitude}, distance=$distance meters.");

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

    // Kirim update ke UI
    service.invoke('update', {
      "distance": currentDistanceInMeters,
      "location": latestLocation,
    });
  }).onError((error) {
    _log(service, LogLevel.error, "Geolocator Stream Error", error);
  });

  // =========================================================================
  // LISTENER UNTUK PERINTAH DARI UI
  // =========================================================================

  service.on('startRecording').listen((event) {
    _log(service, LogLevel.info,
        "==> Event 'startRecording' received with data: $event");
    if (isRecording) {
      _log(service, LogLevel.warning,
          "startRecording called, but a session is already active.");
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
    Pedometer().stepCountStream().first.then((value) => totalStepsAtStart = value);

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
      });
      latestLocation = null;

      // Update notifikasi foreground
      final String content =
          "Time: ${NumberHelper().formatDuration(elapsedTimeInSeconds)}, Distance: ${NumberHelper().formatDistanceMeterToKm(currentDistanceInMeters)}";
      service.invoke(
        'update_notification',
        {
          "title":
              isPaused ? "Record Activity Paused" : "Record Activity Active",
          "content": content,
        },
      );
    });
  });

  service.on('stopRecording').listen((event) {
    _log(service, LogLevel.info, "==> Event 'stopRecording' received.");
    isRecording = false;
    isPaused = false;
    updateTimer?.cancel();
    // Kirim data final ke UI jika perlu
    service.invoke('final_update', {/* data final */});
  });

  service.on('pause').listen((event) {
    _log(service, LogLevel.info, "==> Event 'pause' received.");
    if (!isPaused && isRecording) {
      isPaused = true;
    }
  });

  service.on('resume').listen((event) {
    _log(service, LogLevel.info, "==> Event 'resume' received.");
    if (isPaused && isRecording) {
      isPaused = false;
      justResumed = true;
    }
  });

  service.on('stopService').listen((event) {
    _log(service, LogLevel.warning,
        "==> Event 'stopService' received. Shutting down.");
    updateTimer?.cancel();
    // Tidak perlu membatalkan stream utama karena mereka terikat pada siklus hidup service
    service.stopSelf();
  });

  service.invoke('service_ready');
  _log(service, LogLevel.info, "All listeners are set up. Service is ready.");
}

void _log(ServiceInstance service, LogLevel level, String message,
    [dynamic error]) {
  service.invoke('log', {
    'level': level.toString(),
    'message': message,
    if (error != null) 'error': error.toString(),
  });
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
