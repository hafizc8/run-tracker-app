import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';

class HomeController extends GetxController {
  // --- STATE ---
  final RxInt _currentSteps = 0.obs;
  int get currentSteps => _currentSteps.value;

  final RxInt _validatedSteps = 0.obs;
  int get validatedSteps => _validatedSteps.value;

  final RxString _error = ''.obs;
  String get error => _error.value;

  final AuthService _authService = sl<AuthService>();
  UserModel? get user => _authService.user;

  RxBool isLoadingGetUserData = true.obs;

  // --- SENSOR & VALIDATION LOGIC ---
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  final List<double> _accelerationMagnitudes = [];
  int _lastPedometerSteps = 0;

  // --- PERSISTENT STORAGE (GetStorage) ---
  final _storage = GetStorage();
  static const String _validatedStepsKey = 'validated_steps';
  static const String _lastSavedDateKey = 'last_saved_date';
  static const String _lastPedometerValueKey = 'last_pedometer_value';


  // --- KONFIGURASI VALIDASI ---
  final int _bufferSize = 50;
  final double _magnitudeThreshold = 1.5;

  @override
  void onInit() async {
    super.onInit();
    // 1. Muat data langkah dari sesi sebelumnya
    await _loadDataFromStorage();
    // 2. Inisialisasi sensor
    _initPedometerAndValidator();
    // 3. Muat data pengguna
    _waitForUser();
    // 4. Atur listener untuk menyimpan data secara otomatis setiap kali ada perubahan
    ever(_validatedSteps, (_) => _saveDataToStorage());
  }

  @override
  void onClose() {
    _stepCountSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.onClose();
  }

  /// Memuat data dari GetStorage saat aplikasi dimulai.
  Future<void> _loadDataFromStorage() async {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastSavedDate = _storage.read(_lastSavedDateKey);

    if (lastSavedDate == todayString) {
      // Jika masih di hari yang sama, muat progres sebelumnya
      _validatedSteps.value = _storage.read(_validatedStepsKey) ?? 0;
      _lastPedometerSteps = _storage.read(_lastPedometerValueKey) ?? 0;
      if (kDebugMode) {
        print('Memuat data dari hari yang sama. Langkah tervalidasi: ${_validatedSteps.value}');
      }
    } else {
      // Jika ini hari baru, reset semua data
      if (kDebugMode) print('Hari baru terdeteksi. Mereset data langkah.');
      _validatedSteps.value = 0;
      _lastPedometerSteps = 0;
      // Hapus data lama dari storage
      await _storage.remove(_validatedStepsKey);
      await _storage.remove(_lastPedometerValueKey);
      await _storage.remove(_lastSavedDateKey);
    }
  }

  /// Menyimpan data langkah saat ini ke GetStorage.
  Future<void> _saveDataToStorage() async {
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _storage.write(_validatedStepsKey, _validatedSteps.value);
    await _storage.write(_lastSavedDateKey, todayString);
    await _storage.write(_lastPedometerValueKey, _lastPedometerSteps);
  }


  // --- SENSOR & VALIDATION METHODS ---

  void _initPedometerAndValidator() {
    _accelerometerSubscription = userAccelerometerEventStream().listen(
      (UserAccelerometerEvent event) {
        final double magnitude = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
        _addMagnitudeToBuffer(magnitude);
      },
      onError: (e) {
        if (kDebugMode) print("Accelerometer Error: $e");
      },
      cancelOnError: true,
    );

    try {
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: (error) {
          _error.value = 'Sensor langkah tidak tersedia atau izin ditolak.';
          if (kDebugMode) print('Pedometer Error: $error');
        },
        cancelOnError: true,
      );
    } catch (e, stack) {
      _error.value = 'Gagal menginisialisasi pedometer.';
      if (kDebugMode) print('Error initializing pedometer: $e');
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  void _addMagnitudeToBuffer(double magnitude) {
    if (_accelerationMagnitudes.length >= _bufferSize) {
      _accelerationMagnitudes.removeAt(0);
    }
    _accelerationMagnitudes.add(magnitude);
  }

  void _onStepCount(StepCount event) {
    if (error.isNotEmpty) _error.value = '';

    // Tetapkan basis awal jika ini event pertama di sesi ini
    if (_lastPedometerSteps == 0 && event.steps > 0) {
      if (kDebugMode) print('Menetapkan basis awal pedometer: ${event.steps}');
      _lastPedometerSteps = event.steps;
    }
    
    int newStepsDetected = event.steps - _lastPedometerSteps;

    if (newStepsDetected > 0) {
      // === BAGIAN BARU UNTUK LOGGING ===
      // Hitung magnitudo rata-rata saat ini
      double averageMagnitude = _accelerationMagnitudes.isNotEmpty ? _accelerationMagnitudes.average : 0;
      bool isStepValid = averageMagnitude > _magnitudeThreshold;
      
      // Kirim data ke Firebase Crashlytics
      _logStepAnalysisToCrashlytics(
        averageMagnitude: averageMagnitude,
        isStepValid: isStepValid,
        stepsDetected: newStepsDetected
      );
      // === AKHIR BAGIAN BARU ===
      
      if (_isMovingSignificantly()) {
        _validatedSteps.value += newStepsDetected;
        if (kDebugMode) print('Langkah tervalidasi: +$newStepsDetected. Total: ${_validatedSteps.value}');
      } else {
        if (kDebugMode) print('Langkah terdeteksi tapi diabaikan (tidak cukup gerakan signifikan).');
      }
    }

    _currentSteps.value = event.steps;
    _lastPedometerSteps = event.steps;
  }

  bool _isMovingSignificantly() {
    if (_accelerationMagnitudes.length < _bufferSize * 0.5) return false;
    double averageMagnitude = _accelerationMagnitudes.average;
    return averageMagnitude > _magnitudeThreshold;
  }

  /// Mengirim data analisis langkah ke Crashlytics sebagai Non-Fatal Exception
  void _logStepAnalysisToCrashlytics({
    required double averageMagnitude,
    required bool isStepValid,
    required int stepsDetected
  }) {
    final crashlytics = FirebaseCrashlytics.instance;

    // Gunakan setCustomKey untuk melampirkan data terstruktur.
    // Ini akan muncul di tab "Keys" pada laporan Crashlytics.
    crashlytics.setCustomKey('avg_magnitude', averageMagnitude.toStringAsFixed(4));
    crashlytics.setCustomKey('is_step_valid', isStepValid);
    crashlytics.setCustomKey('steps_detected', stepsDetected);
    crashlytics.setCustomKey('current_threshold', _magnitudeThreshold);

    // Buat "error" non-fatal palsu untuk mengirim laporan.
    // Pesan ini akan menjadi judul laporan di dasbor Crashlytics.
    final exception = Exception('Step Analysis Data: ${isStepValid ? "VALID" : "REJECTED"}');

    // Kirim laporan. `fatal: false` adalah bagian yang paling penting.
    crashlytics.recordError(
      exception,
      null, // Stack trace tidak diperlukan untuk ini
      reason: 'Step Analysis Data', // 'reason' bisa digunakan untuk filtering
      fatal: false,
    );
  }

  double get progressValue => (validatedSteps / (user?.userPreference?.dailyStepGoals ?? 0)).clamp(0.0, 1.0);

  void _waitForUser() async {
    await Future.delayed(const Duration(seconds: 1));

    // Check immediately when the controller starts.
    if (_authService.user != null) {
      isLoadingGetUserData.value = false;
      print("User found immediately in storage.");
    } else {
      print("User not found. Waiting for other services to load...");

      await Future.delayed(const Duration(milliseconds: 500));
      
      // After the delay, check one more time.
      if (_authService.user != null) {
        isLoadingGetUserData.value = false;
        print("User found after delay.");
      } else {
        isLoadingGetUserData.value = false;
        _error.value = "User session could not be loaded.";
        print("User still not found. Stopping loading state.");
      }
      
      // Manually trigger a UI update to be safe.
      update();
    }
  }






  // For icon streak
  final iconPosition = const Offset(20, 100).obs;

  final double iconSize = 26.0;
  final double margin = 18.0;

  // Method untuk memperbarui posisi ikon saat digeser
  void updateIconPosition(DragUpdateDetails details, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;

    double newDx = iconPosition.value.dx + details.delta.dx;
    double newDy = iconPosition.value.dy + details.delta.dy;

    // Batasi gerakan agar tidak keluar dari layar (Clamping)
    newDx = newDx.clamp(margin, screenSize.width - iconSize - margin);
    newDy = newDy.clamp(
      safeArea.top + margin, // Mulai dari bawah AppBar/Notch
      screenSize.height - iconSize - margin - safeArea.bottom,
    );
    
    // Perbarui nilai .value dari Rx<Offset>
    iconPosition.value = Offset(newDx, newDy);
  }

  // Method untuk menempelkan ikon ke tepi saat geseran selesai
  void snapIconToEdge(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double currentDx = iconPosition.value.dx;
    double currentDy = iconPosition.value.dy;

    if (currentDx < (screenSize.width - iconSize) / 2) {
      // Jika lebih dekat ke kiri, tempelkan ke kiri
      iconPosition.value = Offset(margin, currentDy);
    } else {
      // Jika lebih dekat ke kanan, tempelkan ke kanan
      iconPosition.value = Offset(screenSize.width - iconSize - margin, currentDy);
    }
  }
}
