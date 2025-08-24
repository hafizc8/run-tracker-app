import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/daily_record_model.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/models/model/popup_notification_model.dart';
import 'package:zest_mobile/app/core/models/model/record_daily_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/fcm_service.dart';
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
import 'package:zest_mobile/app/routes/app_routes.dart';

class HomeController extends GetxController {
  // --- DEPENDENCIES ---
  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  final _logService = sl<LogService>();
  final _recordActivityService = sl<RecordActivityService>();

  // --- UI STATE ---
  final RxInt validatedSteps = 0.obs;

  // ✨ State untuk waktu aktif ditambahkan kembali ✨
  final RxInt _totalActiveTimeInSeconds = 0.obs;
  int get totalActiveTimeInSeconds => _totalActiveTimeInSeconds.value;

  final RxString _error = ''.obs;
  String get error => _error.value;

  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxBool isLoadingGetUserData = true.obs;
  Rx<HomePageDataModel?> homePageData = Rx<HomePageDataModel?>(null);

  Timer? _syncTimer;
  static const _syncInterval = Duration(minutes: 3);

  Timer? _syncTimerRefreshStepUI;
  static const _syncIntervalRefreshStepUI = Duration(seconds: 5);
  
  // ✨ --- State baru untuk menampung data langkah per jam --- ✨
  var hourlySteps = <int, int>{}.obs; // Map<Jam, Jumlah_Langkah>

  // ✨ KUNCI #1: Tambahkan GlobalKey untuk mendapatkan posisi widget stamina
  final LayerLink staminaLayerLink = LayerLink();
  var isStaminaPopupVisible = false.obs;
  Timer? _popupTimer;

  // ✨ --- STATE BARU UNTUK STAMINA RECOVERY --- ✨
  Timer? _staminaRecoveryTimer;
  // Variabel reaktif untuk menampilkan sisa waktu di UI
  var staminaRecoveryCountdown = "--:--:--".obs;

  Rx<DailyRecordModel?> lastRecord = Rx<DailyRecordModel?>(null);

  @override
  void onInit() async {
    super.onInit();
    _logService.log.i("HomeController: onInit started.");

    // Cek status service di paling awal ✨
    _checkForOngoingActivity();

    isLoadingGetUserData.value = true;
    try {
      // ✨ KUNCI #1: Alur inisialisasi yang baru dan lebih efisien ✨
      
      await refreshData();

      // 2. Sinkronkan hari-hari yang terlewat terlebih dahulu
      await _syncMissingDailyRecords();

      // 3. Lakukan sinkronisasi pertama untuk HARI INI menggunakan metode per jam
      await _syncTodaysData();
      
      // 4. Setelah semua data siap, baru mulai proses latar belakang
      _startPeriodicSync();
      _startStaminaRecoveryTimer();
      _showPopupNotifications();
      _refreshStepUI();

    } catch (e, s) {
      _logService.log.e("Critical error during HomeController init.", error: e, stackTrace: s);
    } finally {
      isLoadingGetUserData.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _logService.log.i("HomeController: onReady.");
    FcmService.markAppAsReady(); 
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    _syncTimerRefreshStepUI?.cancel();
    _popupTimer?.cancel();
    _staminaRecoveryTimer?.cancel();
    _logService.log.i("HomeController: onClose.");
    super.onClose();
  }

  Future<void> _requestPermissions() async {
    // Minta Izin Activity Recognition
    var activityStatus = await Permission.activityRecognition.request();

    if (!activityStatus.isGranted) {
      Get.snackbar("Permission Denied", "Activity sensor permission is required.");
      _logService.log.w("Activity Recognition permission denied.");
      return;
    }
  }

  double get progressValue => (validatedSteps.value / (user.value?.userPreference?.dailyStepGoals ?? 0)).clamp(0.0, 1.0);

  Future<void> _getLastRecord() async {
    lastRecord.value = await _recordActivityService.getDailyRecord(limit: 1).then((value) => value.data.firstOrNull);
  }

  /// ✨ KUNCI #2: Fungsi baru untuk menyinkronkan data hari ini berdasarkan data per jam.
  Future<void> _syncTodaysData() async {
    await _requestPermissions();
    
    _logService.log.i("Syncing today's hourly step data...");
    final today = DateTime.now();
    
    // Dapatkan data per jam untuk hari ini
    await _fetchHourlyStepData(today);
    
    final localTotalSteps = hourlySteps.values.fold(0, (sum, item) => sum + item);
    
    // Rekonsiliasi dengan data backend
    final backendSteps = homePageData.value?.recordDaily?.step ?? 0;
    final authoritativeSteps = max(backendSteps, localTotalSteps);

    // Perbarui UI dengan nilai yang paling benar
    validatedSteps.value = authoritativeSteps;
    _totalActiveTimeInSeconds.value = _estimateActiveTime(authoritativeSteps);

    if (hourlySteps.isEmpty && localTotalSteps == 0) {
      _logService.log.i("No steps recorded today to sync.");
      return;
    }

    if (backendSteps == localTotalSteps) {
      _logService.log.i("Today's data already synced.");
      return;
    }

    final lastSyncedTimestamp = lastRecord.value?.lastTimestamp;

    // Konversi data per jam menjadi format yang bisa dikirim ke API
    final recordsToSync = _prepareRecordsFromHourlyData(today, hourlySteps, after: lastSyncedTimestamp);

    // Hanya kirim jika ada data untuk disinkronkan
    if (recordsToSync.isNotEmpty) {
      try {
        await _recordActivityService.syncDailyRecord(records: recordsToSync);
        _logService.log.i("Successfully synced today's hourly data (${recordsToSync.length} records).");
      } catch (e, s) {
        _logService.log.e("Failed to sync today's hourly data.", error: e, stackTrace: s);
      }
    }
  }

  /// ✨ KUNCI #3: Fungsi ini sekarang menggunakan logika per jam untuk mengisi hari yang hilang.
  Future<void> _syncMissingDailyRecords() async {
    await _requestPermissions();

    _logService.log.i("Checking for missing daily records to sync...");

    if (lastRecord.value == null) return;

    final today = DateTime.now();
    final differenceInDays = today.difference(lastRecord.value?.date ?? today).inDays;

    if (differenceInDays <= 0) return;
    _logService.log.w("$differenceInDays day(s) of data are missing. Starting catch-up sync...");

    List<RecordDailyMiniModel> allMissingRecords = [];

    for (int i = 1; i < differenceInDays; i++) { // Gunakan '<' agar tidak menyertakan hari ini
      final dateToSync = lastRecord.value?.date?.add(Duration(days: i)) ?? today;
      
      // Dapatkan data per jam untuk hari yang hilang
      await _fetchHourlyStepData(dateToSync);
      
      if (hourlySteps.isNotEmpty) {
        allMissingRecords.addAll(_prepareRecordsFromHourlyData(dateToSync, hourlySteps));
      }
    }

    if (allMissingRecords.isNotEmpty) {
      try {
        await _recordActivityService.syncDailyRecord(records: allMissingRecords);
        _logService.log.i("Successfully synced ${allMissingRecords.length} missing hourly records.");
      } catch (e, s) {
        _logService.log.e("Failed to sync missing daily records", error: e, stackTrace: s);
      }
    }
  }

  /// ✨ KUNCI #4: Helper untuk mengubah data per jam menjadi List<RecordDailyMiniModel>.
  List<RecordDailyMiniModel> _prepareRecordsFromHourlyData(DateTime date, Map<int, int> hourlyData, {DateTime? after}) {
    List<RecordDailyMiniModel> records = [];
    hourlyData.forEach((hour, steps) {
      final timestamp = DateTime(date.year, date.month, date.day, hour);

      if (after == null || !timestamp.isBefore(after)) {
        records.add(
          RecordDailyMiniModel(
            step: steps,
            timestamp: timestamp,
            time: _estimateActiveTime(steps),
            calorie: 0,
          ),
        );
      }
    });
    return records;
  }

  /// Memulai timer untuk sinkronisasi berkala HANYA untuk data hari ini.
  void _startPeriodicSync() {
    _logService.log.i("Starting periodic sync timer for today's data every ${_syncInterval.inMinutes} mins.");
    _syncTimer = Timer.periodic(_syncInterval, (timer) async {
      await _syncTodaysData();
    });
  }

  void _refreshStepUI() {
    _syncTimerRefreshStepUI = Timer.periodic(_syncIntervalRefreshStepUI, (timer) async {
      // Get from pedometer for step today and update UI
      final steps = await Pedometer().getStepCount(
        from: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        to: DateTime.now(),
      );

      // Update UI
      validatedSteps.value = steps;
    });
  }

  Future<void> _loadMe() async {
    isLoadingGetUserData.value = true;

    try {
      final response = await _authService.me();

      user.value = response;

      if (response.userPreference?.dailyStepGoals == 0) {
        await _showDailyGoalDialog();
      }

      print('server_time: ${response.serverTime}');
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
        _getLastRecord(),
      ]).then((value) {
        _startStaminaRecoveryTimer();
      });
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

  Future<void> _fetchHourlyStepData(DateTime date) async {
    _logService.log.i("Starting hourly step data fetch for ${DateFormat('yyyy-MM-dd').format(date)}");
    hourlySteps.clear(); // Bersihkan data lama

    final startTime = DateTime(date.year, date.month, date.day);
    final endTime = DateTime(date.year, date.month, date.day, 23, 59, 59);

    // Memulai proses rekursif dari rentang satu hari penuh
    await _recursiveStepFetch(startTime, endTime);

    _logService.log.i("Hourly step data fetched: $hourlySteps");
    update(); // Memicu update UI
  }

  /// Fungsi rekursif untuk "menyelam" ke dalam rentang waktu.
  Future<void> _recursiveStepFetch(DateTime start, DateTime end) async {
    // Kondisi berhenti: jika rentang sudah 1 jam atau kurang
    if (end.difference(start).inHours < 1) {
      // Jika rentang di bawah satu jam, kita asumsikan ini adalah data per jam
      final int steps = await _getStepsForPeriod(start, end);
      if (steps > 0) {
        // Simpan data ke dalam map dengan jam sebagai kuncinya
        hourlySteps[start.hour] = (hourlySteps[start.hour] ?? 0) + steps;
      }
      return;
    }

    try {
      final int stepsInPeriod = await _getStepsForPeriod(start, end);
      // Jika ada langkah di dalam rentang waktu ini, "selami" lebih dalam
      if (stepsInPeriod > 0) {
        // Bagi rentang waktu menjadi dua
        final Duration halfDuration = end.difference(start) ~/ 2;
        final DateTime midPoint = start.add(halfDuration);

        // Panggil rekursif untuk kedua paruh waktu
        await _recursiveStepFetch(start, midPoint);
        await _recursiveStepFetch(midPoint.add(const Duration(seconds: 1)), end);
      }
    } catch (e) {
      _logService.log.e("Error during recursive step fetch for $start - $end", error: e);
    }
  }

  /// Fungsi helper untuk mengambil langkah dari Pedometer dengan aman.
  Future<int> _getStepsForPeriod(DateTime from, DateTime to) async {
    try {
      return await Pedometer().getStepCount(from: from, to: to);
    } catch (e) {
      _logService.log.e("Pedometer failed for period $from - $to", error: e);
      return 0;
    }
  }

  /// Estimasi waktu aktif dalam hitungan detik berdasarkan jumlah langkah.
  ///
  /// Rumus yang digunakan adalah 0.05 menit per langkah.
  ///
  /// Contoh:
  /// - 1000 langkah => 50 menit => 3000 detik
  /// - 500 langkah => 25 menit => 1500 detik
  int _estimateActiveTime(int steps) {
    final minutes = (steps * 0.05).ceil();
    return minutes * 60;
  }

  // ✨ --- FUNGSI BARU UNTUK MENGELOLA ANTRIAN POPUP --- ✨
  Future<void> _showPopupNotifications() async {
    // Buat salinan dari daftar notifikasi agar kita bisa memodifikasinya
    final notificationQueue =
        List<PopupNotificationModel>.from(user.value?.popupNotifications ?? []);

    if (notificationQueue.isEmpty) {
      _logService.log.i("No popup notifications to show.");
      return;
    }

    _logService.log.i(
        "Found ${notificationQueue.length} popup notifications. Showing them sequentially.");

    // Gunakan perulangan `for...of` agar `await` berfungsi dengan benar
    for (var notification in notificationQueue) {
      // Tampilkan dialog dan TUNGGU sampai dialog ditutup
      final result = await Get.dialog(
        showDialogByType(notification),
        barrierDismissible: false,
      );

      _logService.log.i(
          "Popup for notification ID ${notification.id} closed with result: $result");

      // Setelah dialog ditutup, panggil API untuk menandai notifikasi sudah dibaca
      try {
        await _userService.readPopupNotification(ids: [notification.id!]);
        _logService.log.i("Notification ID ${notification.id} marked as read.");
      } catch (e, s) {
        _logService.log
            .e("Failed to mark notification as read.", error: e, stackTrace: s);
      }

      if (result == 'share') {
        Future.delayed(
          const Duration(seconds: 2),
          () {
            if (notification.typeText == 'AchieveStreak') {
              Get.toNamed(
                AppRoutes.shareDailyGoals,
                arguments: {
                  'title': notification.title ?? '',
                  'description': notification.data['description'] ?? '',
                  'imageUrl': notification.imageUrl ?? '',
                }
              );
            } else if (notification.typeText == 'LevelUp') {
              Get.toNamed(
                AppRoutes.shareLevelUp,
                arguments: {
                  'title': notification.title ?? '',
                  'description': notification.data['description'] ?? '',
                  'imageUrl': notification.imageUrl ?? '',
                }
              );
            } else if (notification.typeText == 'AchieveBadge') {
              Get.toNamed(
                AppRoutes.shareBadges,
                arguments: {
                  'title': notification.title ?? '',
                  'description': notification.data['description'] ?? '',
                  'imageUrl': notification.imageUrl ?? '',
                }
              );
            }
          }
        );
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
        notification.data['daily_step_goals'] =
            user.value?.userPreference?.dailyStepGoals ?? 0;
        return AchieveStreakDialog(notification: notification);
      case 'AchieveBadge':
        return AchieveBadgeDialog(notification: notification);
      default:
        return Container();
    }
  }

  /// Menampilkan popup dan memulai timer untuk menutup otomatis.
  void showStaminaPopup() {
    // Jangan tampilkan jika sudah terlihat
    if (isStaminaPopupVisible.value) return;

    isStaminaPopupVisible.value = true;
    _popupTimer?.cancel(); // Batalkan timer lama jika ada
    _popupTimer = Timer(const Duration(seconds: 3), () {
      hideStaminaPopup();
    });
  }

  /// Menyembunyikan popup dan membatalkan timer.
  void hideStaminaPopup() {
    // Jangan sembunyikan jika sudah tidak terlihat
    if (!isStaminaPopupVisible.value) return;

    isStaminaPopupVisible.value = false;
    _popupTimer?.cancel();
  }

  // ✨ --- FUNGSI BARU UNTUK MENGELOLA COUNTDOWN --- ✨
  void _startStaminaRecoveryTimer() {
    // Selalu batalkan timer lama sebelum memulai yang baru
    _staminaRecoveryTimer?.cancel();

    // 1. Ambil semua data yang diperlukan dari model user
    final staminaData = user.value?.currentUserStamina;
    final serverTime = user.value?.serverTime;
    final recoveryMinutes = user.value?.staminaReplenishmentMinute;
    final maxStamina =
        user.value?.currentUserXp?.levelDetail?.staminaIncreaseTotal;

    // 2. Lakukan validasi: jangan jalankan timer jika data tidak lengkap
    if (staminaData == null ||
        serverTime == null ||
        recoveryMinutes == null ||
        staminaData.updatedAt == null ||
        maxStamina == null) {
      staminaRecoveryCountdown.value = "N/A";
      return;
    }

    // 3. Jangan jalankan timer jika stamina sudah penuh
    if ((staminaData.currentAmount ?? 0) >= maxStamina) {
      staminaRecoveryCountdown.value = "Full";
      return;
    }

    // 4. Hitung waktu kapan stamina berikutnya akan pulih
    final recoveryPeriod = Duration(minutes: recoveryMinutes);
    final nextRecoveryTime = staminaData.updatedAt!.add(recoveryPeriod);

    // Hitung selisih waktu antara jam server dan jam lokal
    final timeOffset = serverTime.difference(DateTime.now());

    // 5. Buat Timer yang berjalan setiap detik
    _staminaRecoveryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Dapatkan "waktu server saat ini" yang diestimasi dengan menambahkan offset
      final estimatedServerTime = DateTime.now().add(timeOffset);

      // Hitung sisa waktu
      final timeRemaining = nextRecoveryTime.difference(estimatedServerTime);

      if (timeRemaining.isNegative || timeRemaining.inSeconds <= 0) {
        // Jika waktu sudah habis, tampilkan "Ready!" dan hentikan timer
        staminaRecoveryCountdown.value = "Ready!";
        timer.cancel();
        // Secara opsional, panggil refreshData() setelah beberapa detik
        // untuk mendapatkan data stamina yang baru dari server.
        Future.delayed(const Duration(seconds: 2), () => refreshData());
      } else {
        // Format sisa waktu menjadi HH:MM:SS
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        final hours = twoDigits(timeRemaining.inHours);
        final minutes = twoDigits(timeRemaining.inMinutes.remainder(60));
        final seconds = twoDigits(timeRemaining.inSeconds.remainder(60));
        staminaRecoveryCountdown.value = "$hours:$minutes:$seconds";
      }
    });
  }

  /// ✨ Fungsi baru untuk memeriksa dan mengarahkan jika ada aktivitas ✨
  Future<void> _checkForOngoingActivity() async {
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();

    if (isRunning) {
      _logService.log.w("Ongoing activity detected. Redirecting to RecordActivityView.");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(AppRoutes.activityRecord);
      });
    }
  }
}