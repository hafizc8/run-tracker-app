import 'dart:async';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/services/record_activity_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/modules/home/widgets/set_daily_goals_dialog.dart';
import 'dart:math';
// import 'package:pedometer_2/pedometer_2.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  // --- DEPENDENCIES ---
  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  final _logService = sl<LogService>();
  final _recordActivityService = sl<RecordActivityService>();
  final _prefs = sl<SharedPreferences>();
  final _initialGoalSetKey = 'initial_goal_has_been_set';

  // --- UI STATE ---
  final RxInt _validatedSteps = 0.obs;
  int get validatedSteps => _validatedSteps.value;

  // ✨ State untuk waktu aktif ditambahkan kembali ✨
  final RxInt _totalActiveTimeInSeconds = 0.obs;
  int get totalActiveTimeInSeconds => _totalActiveTimeInSeconds.value;

  final RxString _error = ''.obs;
  String get error => _error.value;

  UserModel? get user => _authService.user;
  RxBool isLoadingGetUserData = true.obs;
  Rx<HomePageDataModel?> homePageData = Rx<HomePageDataModel?>(null);

  Timer? _syncTimer;
  static const _syncInterval = Duration(minutes: 2);
  final _lastSyncedStepsKey = 'last_synced_steps';
  final _lastSavedDateKey = 'last_saved_date';

  @override
  void onInit() async {
    super.onInit();
    _logService.log.i("HomeController: onInit.");

    // ✨ --- ALUR INISIALISASI BARU YANG LEBIH ROBUST --- ✨
    isLoadingGetUserData.value = true;
    try {
      // 1. Minta izin terlebih dahulu
      await _requestPermissions();

      // 2. Ambil data dari backend sebagai sumber kebenaran utama
      await refreshData();

      // 3. Lakukan rekonsiliasi dengan data lokal, reset jika hari baru, dan sync
      await _reconcileAndSyncInitialData();

      // 4. Setelah data sinkron, mulai sinkronisasi berkala
      _startPeriodicSync();

      // 5. Tampilkan dialog jika perlu
      await _checkAndShowDailyGoalDialog();
    } catch (e, s) {
      _logService.log.e("Critical error during HomeController init.",
          error: e, stackTrace: s);
      _error.value = "Failed to initialize home data.";
    } finally {
      isLoadingGetUserData.value = false;
    }
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    _logService.log.i("HomeController: onClose.");
    super.onClose();
  }

  Future<void> _requestPermissions() async {
    // Minta Izin Activity Recognition
    var activityStatus = await Permission.activityRecognition.request();
    if (!activityStatus.isGranted) {
      Get.snackbar(
          "Permission Denied", "Activity sensor permission is required.");
      _logService.log.w("Activity Recognition permission denied.");
      return;
    }
  }

  double get progressValue =>
      (validatedSteps / (user?.userPreference?.dailyStepGoals ?? 0))
          .clamp(0.0, 1.0);

  Future<void> _reconcileAndSyncInitialData() async {
    _logService.log.i("Reconciling step data...");
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastSavedDate = _prefs.getString(_lastSavedDateKey);

    // 1. Reset 'last_synced_steps' jika ini hari baru
    if (lastSavedDate != todayString) {
      _logService.log.w("New day detected. Resetting last synced steps to 0.");
      await _prefs.setInt(_lastSyncedStepsKey, 0);
      await _prefs.setString(_lastSavedDateKey, todayString);
    }

    // 2. Ambil data dari Pedometer
    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day);
    int pedometerSteps = 0;
    try {
      // pedometerSteps = await Pedometer().getStepCount(from: startTime, to: now);
    } catch (e) {
      _logService.log
          .e("Failed to get initial step count from Pedometer.", error: e);
    }

    // 3. Ambil data dari backend (sudah di-fetch oleh refreshData)
    final backendSteps = homePageData.value?.recordDaily?.step ?? 0;

    // 4. Tentukan nilai yang "benar" dengan mengambil yang terbesar
    final authoritativeSteps = max(backendSteps, pedometerSteps);

    _logService.log.i(
        "Reconciliation: Backend ($backendSteps) vs Pedometer ($pedometerSteps). Authoritative: $authoritativeSteps steps.");

    // 5. Atur state UI dengan nilai yang paling benar
    _validatedSteps.value = authoritativeSteps;

    // 6. ✨ PENTING: Lakukan sinkronisasi pertama kali secara langsung
    await syncDailyRecord();
  }

  Future<void> syncDailyRecord() async {
    // Selalu ambil data terbaru dari Pedometer sebelum sync
    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day);
    int currentPedometerSteps = 0;
    try {
      // currentPedometerSteps =
      //     await Pedometer().getStepCount(from: startTime, to: now);

      // get step di jam 13:30 sd 13:40
      final startTimeTest = DateTime(2025, 7, 11, 13, 30);
      final endTimeTest = DateTime(2025, 7, 11, 13, 40);

      // int testGetSteps =
      //     await Pedometer().getStepCount(from: startTimeTest, to: endTimeTest);
      // _logService.log
      //     .i("TEST: $startTimeTest to $endTimeTest = $testGetSteps steps.");

      // get step di jam 13:35 sd 13:36
      final startTimeTest2 = DateTime(2025, 7, 11, 13, 35);
      final endTimeTest2 = DateTime(2025, 7, 11, 13, 36);

      // int testGetSteps2 = await Pedometer()
      //     .getStepCount(from: startTimeTest2, to: endTimeTest2);
      // _logService.log
      //     .i("TEST: $startTimeTest2 to $endTimeTest2 = $testGetSteps2 steps.");
    } catch (e) {
      _logService.log.e("Failed to get step count during sync.", error: e);
      return; // Hentikan jika gagal mengambil data
    }

    // Perbarui UI dengan data terbaru
    _validatedSteps.value = currentPedometerSteps;

    final lastSyncedSteps = _prefs.getInt(_lastSyncedStepsKey) ?? 0;

    // Hanya kirim jika ada progres baru
    if (currentPedometerSteps > lastSyncedSteps) {
      _logService.log
          .i("SYNC: Attempting to sync (Steps: $currentPedometerSteps)");
      try {
        await _recordActivityService.syncDailyRecord(
          step: currentPedometerSteps,
          time: 0, // Anda bisa menambahkan logika waktu jika perlu
          calorie: 0,
        );

        // Jika berhasil, perbarui nilai terakhir yang disinkronkan
        await _prefs.setInt(_lastSyncedStepsKey, currentPedometerSteps);
        _logService.log.i("SYNC: Success.");
      } catch (e, s) {
        _logService.log.e("SYNC: Failed.", error: e, stackTrace: s);
      }
    } else {
      _logService.log.i("SYNC: No new progress to sync.");
    }
  }

  void _startPeriodicSync() {
    _logService.log.i(
        "Starting periodic sync timer every ${_syncInterval.inMinutes} mins.");
    _syncTimer = Timer.periodic(_syncInterval, (timer) async {
      await syncDailyRecord();
    });
  }

  Future<void> _loadMe() async {
    isLoadingGetUserData.value = true;

    try {
      await _authService.me();
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
    isLoadingGetUserData.value = true;
    try {
      // Jalankan keduanya secara bersamaan untuk efisiensi
      await Future.wait([
        _loadMe(),
        _loadHomePageData(),
      ]);
    } finally {
      isLoadingGetUserData.value = false;
    }
  }

  // ✨ KUNCI: Fungsi untuk memeriksa dan menampilkan dialog
  Future<void> _checkAndShowDailyGoalDialog() async {
    // Jangan tampilkan dialog jika data user belum ada
    if (user == null) return;

    final bool hasAlreadySetGoal = _prefs.getBool(_initialGoalSetKey) ?? false;

    // Jika tanggal terakhir disimpan tidak sama dengan hari ini, tampilkan dialog
    if (!hasAlreadySetGoal) {
      Get.dialog(
        SetDailyGoalDialog(
          onSave: (selectedGoal) async {
            print('Goal to save: $selectedGoal');
            try {
              // Di sini Anda panggil API untuk menyimpan goal
              var response = await _userService.updateUserPreference(
                  dailyStepGoals: selectedGoal);

              if (response) {
                await _prefs.setBool(_initialGoalSetKey, true);

                // Perbarui state user di aplikasi Anda secara lokal
                // Contoh: user.update((val) { val?.userPreference?.dailyStepGoals = selectedGoal; });

                Get.back(); // Tutup dialog
                Get.snackbar('Success',
                    'Your daily goal has been set to $selectedGoal steps!');

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
}
