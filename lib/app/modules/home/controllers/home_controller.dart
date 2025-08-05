import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/models/model/popup_notification_model.dart';
import 'package:zest_mobile/app/core/models/model/record_daily_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/services/record_activity_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/modules/home/widgets/achieve_badge_dialog.dart';
import 'package:zest_mobile/app/modules/home/widgets/achieve_streak_dialog.dart';
import 'package:zest_mobile/app/modules/home/widgets/leveled_up_dialog.dart';
import 'package:zest_mobile/app/modules/home/widgets/set_daily_goals_dialog.dart';
import 'dart:math';
import 'package:pedometer_2/pedometer_2.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  // --- DEPENDENCIES ---
  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  final _logService = sl<LogService>();
  final _recordActivityService = sl<RecordActivityService>();
  final _prefs = sl<SharedPreferences>();

  // --- UI STATE ---
  final RxInt validatedSteps = 0.obs;

  // ✨ State untuk waktu aktif ditambahkan kembali ✨
  final RxInt _totalActiveTimeInSeconds = 0.obs;
  int get totalActiveTimeInSeconds => _totalActiveTimeInSeconds.value;

  final RxString _error = ''.obs;
  String get error => _error.value;

  UserModel? get user => _authService.user;
  RxBool isLoadingGetUserData = true.obs;
  Rx<HomePageDataModel?> homePageData = Rx<HomePageDataModel?>(null);

  Timer? _syncTimer;
  static const _syncInterval = Duration(seconds: 10);
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

      _syncMissingDailyRecords();

      _showPopupNotifications();
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
      (validatedSteps.value / (user?.userPreference?.dailyStepGoals ?? 0))
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
      pedometerSteps = await Pedometer().getStepCount(from: startTime, to: now);
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
    validatedSteps.value = authoritativeSteps;

    // 6. ✨ PENTING: Lakukan sinkronisasi pertama kali secara langsung
    await syncDailyRecord();
  }

  Future<void> syncDailyRecord() async {
    // Selalu ambil data terbaru dari Pedometer sebelum sync
    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day);
    int currentPedometerSteps = 0;
    try {
      currentPedometerSteps =
          await Pedometer().getStepCount(from: startTime, to: now);
    } catch (e) {
      _logService.log.e("Failed to get step count during sync.", error: e);
      return;
    }

    // Perbarui UI dengan data terbaru
    validatedSteps.value = currentPedometerSteps;

    final lastSyncedSteps = _prefs.getInt(_lastSyncedStepsKey) ?? 0;

    // Hanya kirim jika ada progres baru
    if (currentPedometerSteps > lastSyncedSteps) {
      _logService.log
          .i("SYNC: Attempting to sync (Steps: $currentPedometerSteps)");
      try {
        await _recordActivityService.syncDailyRecord(
          records: [
            RecordDailyMiniModel(
              step: lastSyncedSteps,
              time: 0,
              calorie: 0,
              timestamp: now,
            ),
          ],
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
      final user = await _authService.me();
      if (user.userPreference?.dailyStepGoals == 0) {
        await _showDailyGoalDialog();
      }
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
  Future<void> _showDailyGoalDialog() async {
    Get.dialog(
      SetDailyGoalDialog(
        onSave: (selectedGoal) async {
          try {
            // Di sini Anda panggil API untuk menyimpan goal
            var response = await _userService.updateUserPreference(
                dailyStepGoals: selectedGoal);

            if (response) {
              Get.back();
              Get.snackbar('Success',
                  'Your daily goal has been set to $selectedGoal steps!');

              refreshData();
            }
          } catch (e) {
            print('Failed to save goal: $e');
            Get.snackbar('Error', 'Failed to save your daily goal.');
          }
        },
      ),
      barrierDismissible: false, // User harus mengatur goal
    );
  }

  Future<void> _syncMissingDailyRecords() async {
    _logService.log.i("Checking for missing daily records to sync...");

    // 1. Dapatkan tanggal record terakhir dari server
    final records = await _recordActivityService.getDailyRecord(limit: 1);
    if (records.data.isEmpty) {
      _logService.log.w("No last record date found. Skipping catch-up sync.");
      return;
    }

    final lastRecordDate = records.data.first.date ?? DateTime.now();

    // 2. Hitung selisih hari dengan hari ini
    final today = DateTime.now();
    final differenceInDays = today.difference(lastRecordDate).inDays;

    if (differenceInDays <= 0) {
      _logService.log.i("Data is up to date. No catch-up sync needed.");
      return;
    }

    _logService.log.w(
        "$differenceInDays day(s) of data are missing. Starting catch-up sync...");

    List<RecordDailyMiniModel> recordDailyToSync = [];

    // 3. Lakukan perulangan untuk setiap hari yang hilang
    for (int i = 1; i <= differenceInDays; i++) {
      final dateToSync = lastRecordDate.add(Duration(days: i));

      // Jangan sync untuk hari ini, karena akan ditangani oleh periodic sync
      if (isSameDay(dateToSync, today)) continue;

      try {
        // Tentukan rentang waktu untuk hari yang hilang
        final startTime =
            DateTime(dateToSync.year, dateToSync.month, dateToSync.day);
        final endTime = DateTime(
            dateToSync.year, dateToSync.month, dateToSync.day, 23, 59, 59);

        // 4. Ambil data langkah dari Pedometer
        final stepsForDay =
            await Pedometer().getStepCount(from: startTime, to: endTime);

        if (stepsForDay > 0) {
          _logService.log.i(
              "Syncing data for ${DateFormat('yyyy-MM-dd').format(dateToSync)}: $stepsForDay steps.");

          // 5. Kirim ke backend dengan tanggal yang spesifik
          recordDailyToSync.add(
            RecordDailyMiniModel(
              step: stepsForDay,
              timestamp: dateToSync,
              time: 0,
              calorie: 0,
            ),
          );
          
        }
      } catch (e, s) {
        _logService.log.e(
            "Failed to sync data for day ${DateFormat('yyyy-MM-dd').format(dateToSync)}",
            error: e,
            stackTrace: s);
        // Lanjutkan ke hari berikutnya meskipun ada error
        continue;
      }
    }

    try {
      if (recordDailyToSync.isNotEmpty) {
        await _recordActivityService.syncDailyRecord(
          records: recordDailyToSync,
        );

        _logService.log.i("Successfully synced missing daily records.");
      }
    } catch (e) {
      _logService.log.e("Failed to sync missing daily records", error: e);
    }

    _logService.log.i("Catch-up sync finished.");
  }

  // ✨ --- FUNGSI BARU UNTUK MENGELOLA ANTRIAN POPUP --- ✨
  Future<void> _showPopupNotifications() async {
    // Buat salinan dari daftar notifikasi agar kita bisa memodifikasinya
    final notificationQueue = List<PopupNotificationModel>.from(user?.popupNotifications ?? []);

    if (notificationQueue.isEmpty) {
      _logService.log.i("No popup notifications to show.");
      return;
    }

    _logService.log.i("Found ${notificationQueue.length} popup notifications. Showing them sequentially.");

    // Gunakan perulangan `for...of` agar `await` berfungsi dengan benar
    for (var notification in notificationQueue) {
      // Tampilkan dialog dan TUNGGU sampai dialog ditutup
      final result = await Get.dialog(
        showDialogByType(notification),
        barrierDismissible: false,
      );
      
      _logService.log.i("Popup for notification ID ${notification.id} closed with result: $result");
      
      // Setelah dialog ditutup, panggil API untuk menandai notifikasi sudah dibaca
      try {
        await _userService.readPopupNotification(ids: [notification.id!]);
        _logService.log.i("Notification ID ${notification.id} marked as read.");
      } catch (e, s) {
        _logService.log.e("Failed to mark notification as read.", error: e, stackTrace: s);
      }
    }

    // Setelah semua notifikasi ditampilkan, refresh data user untuk menghapus
    // popupNotifications dari state
    await refreshData();
  }

  // function to show dialog by type (LevelUp, AchieveStreak, AchieveBadge)
  Widget showDialogByType(PopupNotificationModel notification) {
    switch (notification.typeText) {
      case 'LevelUp':
        return LeveledUpDialog(notification: notification);
      case 'AchieveStreak':
        // add daily goals step to notification
        notification.data['daily_step_goals'] = user?.userPreference?.dailyStepGoals ?? 0;
        return AchieveStreakDialog(notification: notification);
      case 'AchieveBadge':
        return AchieveBadgeDialog(notification: notification);
      default:
        return Container();
    }
  }
}
