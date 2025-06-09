import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:zest_mobile/app/core/models/model/activity_data_point_model.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';
import 'package:zest_mobile/app/core/services/local_activity_service.dart';

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

// FUNGSI INI AKAN DIJALANKAN DI ISOLATE TERPISAH
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityDataPointAdapter());

  final localDb = LocalActivityService();

  // --- Variabel State ---
  int elapsedTimeInSeconds = 0;
  int stepsInSession = 0;
  int? initialStepCount;
  double currentDistanceInMeters = 0.0;
  final List<LocationPoint> currentPath = [];
  Map<String, dynamic>? latestLocation;

  bool isPaused = false;
  int? lastStepCountBeforePause;

  Timer? timer;
  StreamSubscription<StepCount>? stepCountSubscription;
  StreamSubscription<Position>? positionSubscription;

  // Mulai Pedometer Stream
  stepCountSubscription = Pedometer.stepCountStream.listen((StepCount event) {
    if (isPaused) {
      lastStepCountBeforePause = event.steps;
      return;
    }

    // ✨ DIUBAH: Logika kalibrasi step saat resume
    if (lastStepCountBeforePause != null) {
      // Saat di-resume, kita "buang" langkah yang terjadi selama pause
      // dengan menyesuaikan initialStepCount.
      int stepsDuringPause = event.steps - lastStepCountBeforePause!;
      initialStepCount = (initialStepCount ?? 0) + stepsDuringPause;
      lastStepCountBeforePause = null; // Reset setelah kalibrasi
    }

    initialStepCount ??= event.steps;
    stepsInSession = event.steps - initialStepCount!;
  });

  // Mulai Geolocator Stream
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
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );

      if (distanceInMeter < 0) return;
      currentDistanceInMeters += distanceInMeter;
    }
    currentPath.add(newPoint);

    latestLocation = {
      "latitude": newPoint.latitude,
      "longitude": newPoint.longitude,
      "timestamp": newPoint.timestamp.toIso8601String(),
    };

    double currentPace = 0;
    if (elapsedTimeInSeconds > 0) {
      currentPace = currentDistanceInMeters / elapsedTimeInSeconds;
    }

    final dataPoint = ActivityDataPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      step: stepsInSession,
      distance: currentDistanceInMeters,
      pace: currentPace,
      time: elapsedTimeInSeconds,
      timestamp: position.timestamp,
    );

    // Simpan ke database lokal Hive
    localDb.addDataPoint(dataPoint);
  });

  // Timer menjadi SATU-SATUNYA yang mengirim data ke UI
  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!isPaused) {
      elapsedTimeInSeconds++;
    }
    
    // Kirim snapshot data lengkap setiap detik
    service.invoke(
      'update',
      {
        "elapsedTime": elapsedTimeInSeconds,
        "steps": stepsInSession,
        "distance": currentDistanceInMeters,
        "location": latestLocation, // Kirim lokasi terakhir yang diketahui
      },
    );
    // Reset `latestLocation` setelah dikirim agar tidak dikirim berulang kali jika tidak ada pergerakan
    latestLocation = null; 
  });

  // Listener untuk event dari UI (misalnya saat tombol stop ditekan)
  service.on('stopService').listen((event) {
    timer?.cancel();
    stepCountSubscription?.cancel();
    positionSubscription?.cancel();
    service.stopSelf();
  });

  // ✨ BARU: Listener untuk event 'pause'
  service.on('pause').listen((event) {
    isPaused = true;
  });

  // ✨ BARU: Listener untuk event 'resume'
  service.on('resume').listen((event) {
    isPaused = false;
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