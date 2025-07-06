import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

class HomeController extends GetxController {
  // --- DEPENDENCIES ---
  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  final _logService = sl<LogService>();
  final _service = FlutterBackgroundService();
  final _recordActivityService = sl<RecordActivityService>();
  final _prefs = sl<SharedPreferences>();
  final _storageKey = 'lastGoalSetDate';

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
  int _lastSyncedSteps = 0;
  int _lastSyncedTime = 0;
  static const _syncInterval = Duration(minutes: 2);

  // --- Hapus semua state & logika sensor dari sini ---

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
      
      // 3. Lakukan rekonsiliasi dengan data lokal
      await _reconcileStepData();

      // 4. Setelah data sinkron, baru mulai semua proses latar belakang
      _listenToBackgroundService();
      _startPeriodicSync();
      
      // 5. Tampilkan dialog jika perlu
      await _checkAndShowDailyGoalDialog();

    } catch (e, s) {
      _logService.log.e("Critical error during HomeController init.", error: e, stackTrace: s);
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

  Future<bool> _requestPermissions() async {
    var activityStatus = await Permission.activityRecognition.request();
    if (!activityStatus.isGranted) {
      Get.snackbar("Permission Denied", "Activity sensor permission is required.");
      _logService.log.w("Activity sensor permission is required.");
      return false;
    }

    _logService.log.i("All necessary permissions granted. Sending 'start_sensors' command to background service.");
    _service.invoke('start_sensors');

    return true;
  }

  void _listenToBackgroundService() {
    _service.on('passive_step_update').listen((data) {
      if (data != null) {
        if (data['steps'] is int) _validatedSteps.value = data['steps'];
        if (data['time'] is int) _totalActiveTimeInSeconds.value = data['time'];
        
        _logService.log.d("HomeController: Received update from background: Steps=${data['steps']}, Time=${data['time']}");
      }
    });
  }

  double get progressValue => (validatedSteps / (user?.userPreference?.dailyStepGoals ?? 0)).clamp(0.0, 1.0);

  void _startPeriodicSync() {
    try {
      _logService.log.i("Memulai timer untuk sinkronisasi langkah setiap ${_syncInterval.inMinutes} menit.");
      _lastSyncedSteps = _prefs.getInt('last_synced_steps') ?? 0;
      _lastSyncedTime = _prefs.getInt('last_synced_time') ?? 0;

      _syncTimer = Timer.periodic(_syncInterval, (timer) async {
        final currentSteps = _validatedSteps.value;
        final currentTime = _totalActiveTimeInSeconds.value;

        if (currentSteps > _lastSyncedSteps || currentTime > _lastSyncedTime) {
          _logService.log.i("SINKRONISASI: Mencoba mengirim (Langkah: $currentSteps, Waktu: $currentTime)");
          try {
            await _recordActivityService.syncDailyRecord(
              step: currentSteps,
              time: currentTime,
              calorie: 0,
            );
            
            _lastSyncedSteps = currentSteps;
            _lastSyncedTime = currentTime;
            await _prefs.setInt('last_synced_steps', _lastSyncedSteps);
            await _prefs.setInt('last_synced_time', _lastSyncedTime);

            _logService.log.i("SINKRONISASI: Berhasil.");
          } catch (e, s) {
            _logService.log.e("SINKRONISASI: Gagal.", error: e, stackTrace: s);
          }
        } else {
          _logService.log.i("SINKRONISASI: Tidak ada progres baru untuk dikirim.");
        }
      });
    } catch (e) {
      _logService.log.e("Gagal memulai timer sinkronisasi.", error: e);
    }
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

  // ✨ --- FUNGSI BARU UNTUK REKONSILIASI DATA --- ✨
  Future<void> _reconcileStepData() async {
    _logService.log.i("Reconciling step and time data...");

    // Ambil data dari backend (sudah di-fetch oleh refreshData)
    final backendSteps = homePageData.value?.recordDaily?.step ?? 0;
    final backendTime = homePageData.value?.recordDaily?.time ?? 0;

    // Ambil data dari storage lokal
    final localSteps = _prefs.getInt('validated_steps') ?? 0;
    final localTime = _prefs.getInt('active_time') ?? 0;

    _logService.log.i("Data Check -> Backend (Steps: $backendSteps, Time: $backendTime) vs Local (Steps: $localSteps, Time: $localTime)");

    // Tentukan nilai yang "benar" dengan mengambil yang terbesar
    final authoritativeSteps = max(backendSteps, localSteps);
    final authoritativeTime = max(backendTime, localTime);

    if (authoritativeSteps > _validatedSteps.value) {
      _logService.log.w("Updating local state with authoritative data. Steps: $authoritativeSteps, Time: $authoritativeTime");
    }

    // Atur state UI dengan nilai yang paling benar
    _validatedSteps.value = authoritativeSteps;
    _totalActiveTimeInSeconds.value = authoritativeTime;

    // Perbarui storage lokal dengan nilai yang benar untuk konsistensi
    await _prefs.setInt('validated_steps', authoritativeSteps);
    await _prefs.setInt('active_time', authoritativeTime);
  }

  // ✨ KUNCI: Fungsi untuk memeriksa dan menampilkan dialog
  Future<void> _checkAndShowDailyGoalDialog() async {
    // Jangan tampilkan dialog jika data user belum ada
    if (user == null) return;

    final lastSetDateString = _prefs.getString(_storageKey);
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
                await _prefs.setString(_storageKey, todayString);
                
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
}
