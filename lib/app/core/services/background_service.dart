import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';

String formatDuration(int totalSeconds) {
  final int hours = totalSeconds ~/ 3600;
  final int minutes = (totalSeconds % 3600) ~/ 60;
  final int seconds = totalSeconds % 60;

  if (hours > 0) {
    return "${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  } else {
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}

String formatDistance(double distanceInMeters) {
  if (distanceInMeters < 1000) {
    return "${distanceInMeters.toStringAsFixed(0)} m";
  } else {
    double distanceInKm = distanceInMeters / 1000;
    return "${distanceInKm.toStringAsFixed(2)} km";
  }
}

// --- Entry Point untuk Service ---
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Listener untuk menghentikan service, ini adalah fallback jika event 'setAppDirectory' belum diterima
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

// --- ✨ SEMUA LOGIKA UTAMA PINDAH KE FUNGSI INI ✨ ---
void setupActivityTracking(ServiceInstance service) {
  print("✅ Background Service: Setting up listeners for tracking...");

  // --- Variabel State ---
  int elapsedTimeInSeconds = 0;
  int stepsInSession = 0;
  int? initialStepCount;
  double currentDistanceInMeters = 0.0;
  final List<LocationPoint> currentPath = [];
  Map<String, dynamic>? latestLocation;
  bool isPaused = false;
  int? lastStepCountBeforePause;

  // --- Stream Subscriptions ---
  Timer? timer;
  StreamSubscription<StepCount>? stepCountSubscription;
  StreamSubscription<Position>? positionSubscription;

  // Fungsi untuk membatalkan semua stream saat service berhenti
  void stopAllStreams() {
    timer?.cancel();
    stepCountSubscription?.cancel();
    positionSubscription?.cancel();
    print("⛔ Background Service: All streams have been canceled.");
  }

  // Definisikan ulang listener 'stopService' di sini agar bisa memanggil stopAllStreams
  service.on('stopService').listen((event) {
    stopAllStreams();
    service.stopSelf();
  });

  // --- Mulai semua listener untuk tracking ---

  stepCountSubscription = Pedometer.stepCountStream.listen((StepCount event) {
    if (isPaused) {
      lastStepCountBeforePause = event.steps;
      return;
    }
    if (lastStepCountBeforePause != null) {
      int stepsDuringPause = event.steps - lastStepCountBeforePause!;
      initialStepCount = (initialStepCount ?? 0) + stepsDuringPause;
      lastStepCountBeforePause = null;
    }
    initialStepCount ??= event.steps;
    stepsInSession = event.steps - initialStepCount!;
  });

  positionSubscription = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    ),
  ).listen((Position position) {
    if (isPaused) return;

    final newPoint = LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );

    if (currentPath.isNotEmpty) {
      final lastPoint = currentPath.last;
      double distanceInMeter = Geolocator.distanceBetween(
        lastPoint.latitude, lastPoint.longitude,
        newPoint.latitude, newPoint.longitude,
      );
      if (distanceInMeter >= 0) {
        currentDistanceInMeters += distanceInMeter;
      }
    }
    currentPath.add(newPoint);

    latestLocation = {
      "latitude": newPoint.latitude,
      "longitude": newPoint.longitude,
      "timestamp": newPoint.timestamp.toIso8601String(),
    };
  });

  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!isPaused) {
      elapsedTimeInSeconds++;
    }
    service.invoke('update', {
      "elapsedTime": elapsedTimeInSeconds,
      "steps": stepsInSession,
      "distance": currentDistanceInMeters,
      "location": latestLocation,
    });
    latestLocation = null;
  });

  // Listener untuk event dari UI
  service.on('pause').listen((event) => isPaused = true);
  service.on('resume').listen((event) => isPaused = false);
  service.on('restoreState').listen((data) {
    if (data == null) return;
    elapsedTimeInSeconds = data['elapsedTime'] ?? 0;
    currentDistanceInMeters = data['distance'] ?? 0.0;
    stepsInSession = data['steps'] ?? 0;
    isPaused = true;
    initialStepCount = null;
    print("Background service state restored.");
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