import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/services/record_activity_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/modules/home/widgets/set_daily_goals_dialog.dart';

class HomeController extends GetxController {
  // --- STATE ---
  final RxInt _currentSteps = 0.obs;
  int get currentSteps => _currentSteps.value;

  final RxInt _validatedSteps = 0.obs;
  int get validatedSteps => _validatedSteps.value;

  final RxString _error = ''.obs;
  String get error => _error.value;

  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  final _recordActivityService = sl<RecordActivityService>();
  final _logService = sl<LogService>();
  UserModel? get user => _authService.user;

  RxBool isLoadingGetUserData = true.obs;
  Rx<HomePageDataModel?> homePageData = Rx<HomePageDataModel?>(null);

  // --- SENSOR & VALIDATION LOGIC ---
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  final List<double> _accelerationMagnitudes = [];
  int _lastPedometerSteps = 0;

  // ✨ --- PERIODIC SYNC LOGIC --- ✨
  Timer? _syncTimer;
  int _lastSyncedSteps = 0; // Melacak jumlah langkah yang terakhir kali berhasil disinkronkan
  static const _syncInterval = Duration(minutes: 3); // Atur interval sinkronisasi (contoh: 3 menit)

  // --- PERSISTENT STORAGE (GetStorage) ---
  final _storage = GetStorage();
  static const String _validatedStepsKey = 'validated_steps';
  static const String _lastSavedDateKey = 'last_saved_date';
  static const String _lastPedometerValueKey = 'last_pedometer_value';
  final _storageKey = 'lastGoalSetDate';

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
    await _loadMe();
    await _loadHomePageData();
    // 4. Tampilkan dialog set daily goal
    await _checkAndShowDailyGoalDialog();
    // 5. Atur listener untuk menyimpan data secara otomatis setiap kali ada perubahan
    ever(_validatedSteps, (_) => _saveDataToStorage());

    _startPeriodicSync();
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
      _logService.log.i('Memuat data dari hari yang sama. Langkah tervalidasi: ${_validatedSteps.value}');
    } else {
      // Jika ini hari baru, reset semua data
      _logService.log.i('Hari baru terdeteksi. Mereset data langkah.');
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
        _logService.log.i("Accelerometer Error: $e");
      },
      cancelOnError: true,
    );

    try {
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: (error) {
          _error.value = 'Sensor langkah tidak tersedia atau izin ditolak.';
          _logService.log.i("Pedometer Error: $error");
        },
        cancelOnError: true,
      );
    } catch (e, stack) {
      _error.value = 'Gagal menginisialisasi pedometer.';
      _logService.log.i("Error initializing pedometer: $e");
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
      _logService.log.i("Menetapkan basis awal pedometer: ${event.steps}");
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
        _logService.log.i("Langkah tervalidasi: +$newStepsDetected. Total: ${_validatedSteps.value}");
      } else {
        _logService.log.i("Langkah terdeteksi tapi diabaikan (tidak cukup gerakan signifikan).");
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

  Future<void> _loadMe() async {
    isLoadingGetUserData.value = true;

    try {
      final user = await _authService.me();
    } catch (e) {
      rethrow;
    } finally {
      isLoadingGetUserData.value = false;
    }
  }

  Future<void> _loadHomePageData() async {
    isLoadingGetUserData.value = true;

    try {
      final response = await _userService.loadHomePageData();

      homePageData.value = response;
    } catch (e) {
      rethrow;
    } finally {
      isLoadingGetUserData.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadMe();
    await _loadHomePageData();
  }

  // ✨ KUNCI: Fungsi untuk memeriksa dan menampilkan dialog
  Future<void> _checkAndShowDailyGoalDialog() async {
    // Jangan tampilkan dialog jika data user belum ada
    if (user == null) return;

    final lastSetDateString = _storage.read<String>(_storageKey);
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Jika tanggal terakhir disimpan tidak sama dengan hari ini, tampilkan dialog
    if (lastSetDateString != todayString) {
      Get.dialog(
        SetDailyGoalDialog(
          onSave: (selectedGoal) async {
            print('Goal to save: $selectedGoal');
            try {
              // Di sini Anda panggil API untuk menyimpan goal
              var response = await _userService.updateUserPreference(
                dailyStepGoals: selectedGoal
              );

              if (response) {
                // Jika berhasil, simpan tanggal hari ini ke storage
                await _storage.write(_storageKey, todayString);
                
                // Perbarui state user di aplikasi Anda secara lokal
                // Contoh: user.update((val) { val?.userPreference?.dailyStepGoals = selectedGoal; });

                Get.back(); // Tutup dialog
                Get.snackbar('Success', 'Your daily goal has been set to $selectedGoal steps!');

                refreshData();
              }


            } catch (e) {
              print('Failed to save goal: $e');
              Get.snackbar('Error', 'Failed to save your daily goal.');
              // Mungkin jangan tutup dialog jika gagal, biarkan user coba lagi
            }
          },
        ),
        barrierDismissible: false, // User harus mengatur goal
      );
    } else {
      print("Daily goal for today has already been set.");
    }
  }

  // ✨ --- FUNGSI BARU UNTUK SINKRONISASI BERKALA --- ✨
  void _startPeriodicSync() {
    _logService.log.i("Memulai timer untuk sinkronisasi langkah setiap ${_syncInterval.inMinutes} menit.");
    // Muat nilai terakhir yang disinkronkan dari storage jika ada
    _lastSyncedSteps = _storage.read<int>('last_synced_steps') ?? 0;

    _syncTimer = Timer.periodic(_syncInterval, (timer) async {
      final currentValidatedSteps = _validatedSteps.value;

      // Hanya kirim jika ada langkah baru sejak sinkronisasi terakhir
      if (currentValidatedSteps > _lastSyncedSteps) {
        _logService.log.i("SINKRONISASI BERKALA: Terdeteksi langkah baru. Mencoba mengirim $currentValidatedSteps langkah.");
        try {
          await _recordActivityService.syncDailyRecord(step: currentValidatedSteps);
          
          // Jika berhasil, perbarui nilai terakhir yang disinkronkan
          _lastSyncedSteps = currentValidatedSteps;
          await _storage.write('last_synced_steps', _lastSyncedSteps);

          _logService.log.i("SINKRONISASI BERKALA: Berhasil mengirim $currentValidatedSteps langkah.");
        } catch (e, s) {
          _logService.log.e("SINKRONISASI BERKALA: Gagal.", error: e, stackTrace: s);
        }
      } else {
        _logService.log.i("SINKRONISASI BERKALA: Tidak ada langkah baru untuk dikirim.");
      }
    });
  }
}
