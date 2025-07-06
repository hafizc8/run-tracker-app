import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';

extension ListAverage on List<double> {
  double get average => isEmpty ? 0.0 : reduce((a, b) => a + b) / length;
}

// Helper function untuk logging
void log(ServiceInstance service, LogLevel level, String message, [dynamic error, StackTrace? stackTrace]) {
  service.invoke('log', {
    'level': level.toString(),
    'message': message,
    if (error != null) 'error': error.toString(),
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
  });
}

// --- Entry Point untuk Service ---
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final prefs = await SharedPreferences.getInstance();

  log(service, LogLevel.info, "onStart initiated. Initializing permanent sensor streams.");

  // --- State Utama Service ---
  bool isRecording = false;
  bool isPaused = false;
  bool areSensorsInitialized = false;

  // --- State Sesi Perekaman ---
  int elapsedTimeInSeconds = 0;
  int stepsInSession = 0;
  int totalStepsAtPause = 0;
  double currentDistanceInMeters = 0.0;
  final List<LocationPoint> currentPath = [];
  Map<String, dynamic>? latestLocation;
  Timer? updateTimer;
  int totalStepsAtStartOfSession = 0;

  // ✨ --- STATE BARU: Untuk Passive All-Day Step Counting --- ✨
  int dailyValidatedSteps = 0;
  int lastPedometerStepsForDaily = 0;
  int totalActiveTimeInSeconds = 0;
  DateTime? lastActivityTimestamp;
  final List<double> accelerationMagnitudes = [];
  const int bufferSize = 50;
  const double magnitudeThreshold = 1.5;

  // ✨ --- LOGIKA BARU UNTUK "BATCH & SAVE" --- ✨
  Timer? saveTimer;
  const saveInterval = Duration(seconds: 30); // Simpan ke disk setiap 30 detik

  // Fungsi untuk menyimpan data saat ini ke storage
  void saveDataToStorage() {
    prefs.setInt('validated_steps', dailyValidatedSteps);
    prefs.setInt('active_time', totalActiveTimeInSeconds);
    prefs.setInt('last_pedometer_value', lastPedometerStepsForDaily);
    prefs.setString('last_saved_date', DateFormat('yyyy-MM-dd').format(DateTime.now()));
    
    log(service, LogLevel.info, "Data saved to storage. Steps: $dailyValidatedSteps");
  }

  void loadDailyStepsFromStorage() {
    final lastSavedDate = prefs.getString('last_saved_date');
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (lastSavedDate == todayString) {
      dailyValidatedSteps = prefs.getInt('validated_steps') ?? 0;
      totalActiveTimeInSeconds = prefs.getInt('active_time') ?? 0;
    } 
    else {
      // Hari baru, reset data
      prefs.setInt('validated_steps', 0);
      prefs.setInt('active_time', 0);
      prefs.setInt('last_pedometer_value', 0);
      prefs.setString('last_saved_date', todayString);
    }

    log(service, LogLevel.info, "Passive tracking state loaded. Steps: $dailyValidatedSteps, Time: $totalActiveTimeInSeconds s");
  }

  loadDailyStepsFromStorage();

  // Mulai timer untuk menyimpan data secara berkala
  saveTimer = Timer.periodic(saveInterval, (timer) {
    saveDataToStorage();
  });

  // =========================================================================
  // KUNCI #1: ARSITEKTUR SENSOR SELALU AKTIF
  // Stream diinisialisasi satu kali saja dan berjalan selama service hidup.
  // Ini mencegah error inisialisasi ulang.
  // =========================================================================

  service.on('start_sensors').listen((event) {
    if (areSensorsInitialized) {
      log(service, LogLevel.warning, "'start_sensors' received, but sensors are already initialized. Ignoring.");
      return;
    }

    areSensorsInitialized = true;
    log(service, LogLevel.info, "==> Event 'start_sensors' received. Initializing sensor listeners for the first time.");

    // --- Listener Pedometer untuk All-Day-Tracking ---
    Pedometer.stepCountStream.listen((StepCount event) {

      if (isRecording) {
        // --- LOGIKA UNTUK SESI AKTIF ---
        if (isPaused) {
          totalStepsAtPause = event.steps;
        } else {
          if (totalStepsAtPause > 0) {
            int stepsDuringPause = event.steps - totalStepsAtPause;
            totalStepsAtStartOfSession += stepsDuringPause;
            totalStepsAtPause = 0;
          }
          stepsInSession = event.steps - totalStepsAtStartOfSession;
        }
      }

      // --- LOGIKA UNTUK PELACAKAN PASIF (HARIAN) ---
      if (lastPedometerStepsForDaily == 0) {
        lastPedometerStepsForDaily = event.steps;
        log(service, LogLevel.info, "First step detected: $lastPedometerStepsForDaily");
      }

      int newStepsDetected = event.steps - lastPedometerStepsForDaily;

      log(service, LogLevel.info, "New Raw steps detected: $newStepsDetected, Average magnitude: ${accelerationMagnitudes.average} (threshold: $magnitudeThreshold)");

      if (newStepsDetected > 0) {

        // ✨ Gunakan extension .average yang sudah kita buat
        double averageMagnitude = accelerationMagnitudes.average;


        if (averageMagnitude > magnitudeThreshold) {
          dailyValidatedSteps += newStepsDetected;

          final now = DateTime.now();
          if (lastActivityTimestamp != null) {
            final timeDifference = now.difference(lastActivityTimestamp!);
            if (timeDifference.inSeconds < 10) {
              totalActiveTimeInSeconds += timeDifference.inSeconds;
            }
          }
          lastActivityTimestamp = now;

          service.invoke('passive_step_update', {
            'steps': dailyValidatedSteps,
            'time': totalActiveTimeInSeconds,
          });
        } else {
          lastActivityTimestamp = null;
        }
      }
      lastPedometerStepsForDaily = event.steps;
      prefs.setInt('last_pedometer_value', lastPedometerStepsForDaily);

    }).onError((error) {
      log(service, LogLevel.error, "Passive Pedometer Error", error);
    });

    // --- Listener Accelerometer untuk validasi ---
    userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      final double magnitude = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
      if (accelerationMagnitudes.length >= bufferSize) {
        accelerationMagnitudes.removeAt(0);
      }
      accelerationMagnitudes.add(magnitude);
    }).onError((error) {
      log(service, LogLevel.error, "Passive Accelerometer Error", error);
    });
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

      log(service, LogLevel.verbose, "Geolocator new position: lat=${position.latitude}, lon=${position.longitude}, distance=$distance meters.");
      
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
    log(service, LogLevel.error, "Geolocator Stream Error", error);
  });

  // =========================================================================
  // LISTENER UNTUK PERINTAH DARI UI
  // =========================================================================

  service.on('startRecording').listen((event) {
    log(service, LogLevel.info, "==> Event 'startRecording' received with data: $event");
    if (isRecording) {
      log(service, LogLevel.warning, "startRecording called, but a session is already active.");
      return;
    }
    // Reset semua state sesi
    elapsedTimeInSeconds = 0;
    stepsInSession = 0;
    currentDistanceInMeters = 0.0;
    currentPath.clear();
    isPaused = false;
    totalStepsAtPause = 0;
    isRecording = true;

    Pedometer.stepCountStream.first.then((value) {
      totalStepsAtStartOfSession = value.steps;
      log(service, LogLevel.info, "Active session started. Initial step offset: $totalStepsAtStartOfSession");
    });

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
    log(service, LogLevel.info, "==> Event 'stopRecording' received.");
    isRecording = false;
    isPaused = false;
    updateTimer?.cancel();
    // Kirim data final ke UI jika perlu
    service.invoke('final_update', { /* data final */ });
  });

  service.on('pause').listen((event) {
    log(service, LogLevel.info, "==> Event 'pause' received.");
    if (!isPaused && isRecording) {
      isPaused = true;
    }
  });

  service.on('resume').listen((event) {
    log(service, LogLevel.info, "==> Event 'resume' received.");
    if (isPaused && isRecording) {
      isPaused = false;
    }
  });
  
  service.on('stopService').listen((event) {
    log(service, LogLevel.warning, "==> Event 'stopService' received. Shutting down.");
    updateTimer?.cancel();
    // Tidak perlu membatalkan stream utama karena mereka terikat pada siklus hidup service
    service.stopSelf();
  });

  service.invoke('service_ready');
  log(service, LogLevel.info, "All listeners are set up. Service is ready.");
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