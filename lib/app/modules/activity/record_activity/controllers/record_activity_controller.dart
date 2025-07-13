import 'dart:async';
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/activity_data_point_model.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';
import 'package:zest_mobile/app/core/models/model/stamina_requirement_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/local_activity_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/services/record_activity_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_dialog_confirmation.dart';
import 'package:zest_mobile/app/modules/activity/record_activity/views/widgets/use_stamina_dialog.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RecordActivityController extends GetxController {
  final _service = FlutterBackgroundService(); // Instance service
  final _localDb = LocalActivityService();
  final _recordActivityService = sl<RecordActivityService>();
  final _locationService = sl<LocationService>();
  final _logService = sl<LogService>();
  final _userService = sl<UserService>();
  final AuthService _authService = sl<AuthService>();
  UserModel? get user => _authService.user;
  final _prefs = sl<SharedPreferences>();
  
  // --- UI State ---
  var isTracking = false.obs;
  var isPaused = false.obs;
  var isLoadingSaveRecordActivity = false.obs;
  var elapsedTimeInSeconds = 0.obs;
  var stepsInSession = 0.obs;
  var currentDistanceInMeters = 0.0.obs;
  var currentPath = <LocationPoint>[].obs;
  var isStartingActivity = false.obs;
  
  // ✨ --- Stamina State --- ✨
  var totalStaminaToUse = 0.obs;
  var staminaRemainingCount = 0.obs; 
  var staminaTotalTimeRemainingInSeconds = 0.obs; 
  Timer? _staminaTimer;
  
  // --- Map State ---
  GoogleMapController? mapController;
  RxBool isMapViewMode = false.obs;

  // --- Session State ---
  String? _recordActivityId;

  var formattedPace = "00:00".obs;
  Timer? _paceUpdateTimer;

  // ✨ --- State Baru untuk Periodic Sync & Coin --- ✨
  var _nextSyncDistanceInKm = 1.0; // Target sync pertama adalah 1 km
  RxDouble coinsEarned = 0.0.obs;
  RxBool isSyncing = false.obs;
  RxDouble userCoin = 0.0.obs;

  // ✨ --- State Baru untuk Animasi Koin --- ✨
  var showCoinAnimation = false.obs;
  Timer? _coinAnimationTimer;

  var staminaRequirements = <StaminaRequirementModel>[].obs;
  // ✨ Kunci baru untuk cache
  final String _staminaConfigCacheKey = 'stamina_config_cache';
  final String _staminaConfigTimestampKey = 'stamina_config_timestamp';


  @override
  void onInit() {
    super.onInit();
    _listenToBackgroundService();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStaminaConfigAndShowDialog();
    });

    userCoin.value = user?.currentUserCoin?.currentAmount ?? 0;
  }

  @override
  void onClose() {
    _logService.log.i("RecordActivityController closed.");
    _staminaTimer?.cancel();
    _paceUpdateTimer?.cancel();
    _coinAnimationTimer?.cancel();
    super.onClose();
  }

  void _listenToBackgroundService() {
    _service.on('update').listen((data) {
      if (data == null || !isTracking.value) return;

      if (data['elapsedTime'] != null) elapsedTimeInSeconds.value = data['elapsedTime'];
      if (data['steps'] != null) stepsInSession.value = data['steps'];
      if (data['distance'] != null) currentDistanceInMeters.value = (data['distance'] as num).toDouble();

      if (data['location'] != null) {
        final loc = data['location'];
        final newPoint = LocationPoint(
          latitude: loc['latitude'],
          longitude: loc['longitude'],
          timestamp: DateTime.parse(loc['timestamp']),
        );
        currentPath.add(newPoint);

        _saveDataPointToLocalDb(loc, newPoint.timestamp);
        _updateCameraForRoute();
      }
    });
  }

  // ✨ --- FUNGSI BARU UNTUK SINKRONISASI PER KM --- ✨
  Future<void> _checkDistanceForPeriodicSync() async {
    double currentDistanceInKm = currentDistanceInMeters.value / 1000.0;
    
    // Cek apakah jarak saat ini sudah mencapai atau melebihi target sync berikutnya
    if (currentDistanceInKm >= _nextSyncDistanceInKm) {
      _logService.log.i("Reached sync milestone: ${_nextSyncDistanceInKm}km. Syncing data...");

      final dataPoints = await _localDb.getAllDataPoints();
      if ((dataPoints.last.distance / 1000) >= _nextSyncDistanceInKm) {
        // Lakukan sinkronisasi
        await _syncActivityData();

        // Setelah berhasil, naikkan target sync berikutnya
        _nextSyncDistanceInKm += 1.0;
        _logService.log.i("Next sync milestone set to: ${_nextSyncDistanceInKm}km.");
      }
      
    }
  }

  /// Fungsi terpusat untuk melakukan sinkronisasi data.
  Future<void> _syncActivityData() async {
    if (_recordActivityId == null) return;
    
    final dataPoints = await _localDb.getAllDataPoints();
    if (dataPoints.isEmpty) {
      _logService.log.w("Sync triggered, but no data points in local DB.");
      return;
    }

    isSyncing.value = true;
    
    try {
      final jsonData = dataPoints.map((p) => p.toJson()).toList();
      // Asumsi service Anda mengembalikan data coin
      final syncResponse = await _recordActivityService.syncRecordActivity(
        recordActivityId: _recordActivityId!,
        data: jsonData,
      );

      // ✨ KUNCI #2: Ambil dan akumulasi koin dari response
      if (syncResponse.coin != null) {
        coinsEarned.value = double.tryParse(syncResponse.coin ?? "0") ?? 0.0;

        if (coinsEarned.value > 0) {
          userCoin.value += coinsEarned.value;
          _triggerCoinAnimation();
        }
        _logService.log.i("Sync successful. Gained ${syncResponse.coin} coins.");
        Get.snackbar("Coins Earned!", "+${syncResponse.coin} coins for reaching a new milestone!", snackPosition: SnackPosition.TOP);
      }
      
      // Hapus data point yang sudah disinkronisasi untuk efisiensi
      await _localDb.clearDataPoints();

    } catch (e, s) {
      _logService.log.e("Periodic sync failed.", error: e, stackTrace: s);
    } finally {
      isSyncing.value = false;
    }
  }

  void togglePauseResume() {
    if (!isTracking.value) return;
    _logService.log.i("Activity ${isPaused.value ? 'paused' : 'resumed'}.");
    isPaused.value = !isPaused.value;
    _service.invoke(isPaused.value ? 'pause' : 'resume');
    Get.snackbar(
        isPaused.value ? "Activity Paused" : "Activity Resumed",
        isPaused.value ? "Tracking is paused." : "Tracking is active again.");
  }

  Future<bool> _requestPermissions() async {
    var activityStatus = await Permission.activityRecognition.request();
    if (!activityStatus.isGranted) {
      Get.snackbar("Permission Denied", "Activity sensor permission is required.");
      _logService.log.w("Activity sensor permission is required.");
      return false;
    }

    var locationStatus = await Permission.locationWhenInUse.request();
    if (!locationStatus.isGranted) {
      Get.snackbar("Permission Denied", "Location permission is required.");
      _logService.log.w("Location permission is required.");
      return false;
    }

    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      Get.snackbar("Location Service Disabled", "Please enable location service.");
      _logService.log.w("Location service is disabled.");
      return false;
    }
    return true;
  }

  /// Fungsi baru untuk mengambil konfigurasi dari API.
  Future<void> _loadStaminaConfigAndShowDialog() async {
    // Tampilkan loading overlay jika diperlukan
    Get.dialog(const Center(child: CircularProgressIndicator()));

    final lastFetchTimestamp = _prefs.getInt(_staminaConfigTimestampKey);
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Cek apakah ada cache dan umurnya kurang dari 7 hari
    if (lastFetchTimestamp != null && (now - lastFetchTimestamp) < const Duration(days: 7).inMilliseconds) {
      final cachedData = _prefs.getString(_staminaConfigCacheKey);
      if (cachedData != null) {
        _logService.log.i("Loading stamina requirements from CACHE.");
        try {
          // Decode JSON string dari cache menjadi List<Map>
          final List<dynamic> decodedList = jsonDecode(cachedData);
          // Konversi setiap map menjadi objek StaminaRequirementModel
          final requirements = decodedList.map((item) => StaminaRequirementModel.fromJson(item)).toList();
          staminaRequirements.assignAll(requirements);

          Get.back(); // Tutup loading overlay

          // Jika berhasil, langsung tampilkan dialog
          await chooseStamina();
          return; // Hentikan eksekusi agar tidak memanggil API
        } catch (e) {
          _logService.log.e("Failed to parse stamina config from cache. Fetching from API instead.", error: e);
        }
      }
    }

    // Jika cache tidak ada atau sudah kedaluwarsa, panggil API
    _logService.log.i("Cache invalid or not found. Fetching stamina requirements from API.");
    try {
      final requirements = await _userService.loadStaminaRequirement();
      staminaRequirements.assignAll(requirements);
      
      // ✨ Simpan hasil dari API ke cache
      final List<Map<String, dynamic>> dataToCache = requirements.map((req) => req.toJson()).toList();
      await _prefs.setString(_staminaConfigCacheKey, jsonEncode(dataToCache));
      await _prefs.setInt(_staminaConfigTimestampKey, now);
      _logService.log.i("Stamina requirements loaded from API and cached.");

      Get.back(); // Tutup loading overlay
      
      await chooseStamina();

    } catch (e, s) {
      _logService.log.e("Failed to load stamina requirements.", error: e, stackTrace: s);
      Get.snackbar("Error", "Could not load stamina settings. Please try again.");
    }
  }

  StaminaRequirementModel? _getRequirementForStamina(int staminaValue) {
    if (staminaRequirements.isEmpty) return null;
    
    for (var req in staminaRequirements) {
      final min = req.staminaUsedMin ?? 0;
      // Jika max null, anggap tidak ada batas atas
      final max = req.staminaUsedMax ?? double.infinity.toInt();
      
      if (staminaValue >= min && staminaValue <= max) {
        return req;
      }
    }
    // Fallback ke item terakhir jika tidak ditemukan (untuk kasus 31+)
    return staminaRequirements.last;
  }

  Future<void> chooseStamina() async {
    _logService.log.i("Showing choose stamina dialog.");

    if (user != null && (user?.currentUserStamina?.currentAmount ?? 0) == 0) {
      _logService.log.i("User has 0 stamina. Starting activity directly.");
      // Langsung mulai aktivitas dengan 0 stamina
      startActivity(staminaToUse: 0);
      return;
    }

    // Jika konfigurasi gagal dimuat, jangan tampilkan dialog
    if (staminaRequirements.isEmpty) {
      _logService.log.w("Stamina requirements are empty. Aborting dialog.");
      return;
    }

    Get.dialog(
      UseStaminaDialog(
        title: 'Stamina',
        subtitleBuilder: (int staminaValue) {
          if (staminaValue == 0) return 'Stamina will not be used';

          final req = _getRequirementForStamina(staminaValue);
          final multiplier = req?.multiplier ?? 1.0;
          return 'Stamina will be used continuously until it runs out\nMultiplier bonus: ${multiplier}x';
        },
        
        // Berikan nilai awal, minimum, dan maksimum untuk stamina
        initialValue: 1,
        minValue: 0,
        maxValue: user?.currentUserStamina?.currentAmount ?? 0,
        
        // Bangun label tombol konfirmasi secara dinamis
        labelConfirmBuilder: (int staminaValue) {
          int totalMinutes = 0;

          if (staminaValue > 0) {
            final req = _getRequirementForStamina(staminaValue);
            final multiplier = req?.sessionMinuteMultiplier ?? 3;
            totalMinutes = staminaValue * multiplier;
          }

          return Text(
            staminaValue == 0
              ? 'Start without Stamina'
              : 'Running Sessions: $totalMinutes mins',
            style: GoogleFonts.poppins(
              fontSize: 12, 
              fontWeight: FontWeight.w700,
              color: const Color(0xFF292929),
            ),
          );
        },

        // Tangani nilai stamina yang dikembalikan saat dikonfirmasi
        onConfirm: (int finalStaminaValue) {
          _logService.log.i("User confirmed to use $finalStaminaValue stamina.");
          // Tutup dialog
          Get.back();
          // Lanjutkan logika Anda dengan nilai stamina ini...
          startActivity(staminaToUse: finalStaminaValue);
        },

        // Anda tetap bisa menggunakan onCancel jika perlu
        labelCancel: 'Back',

        onCancel: () {
          Get.back(closeOverlays: true);
        },
      ),
      barrierDismissible: false, // User harus memilih
    );
  }

  Future<void> startActivity({int staminaToUse = 0}) async {
    _logService.log.i("Attempting to start activity with $staminaToUse stamina.");

    if (isTracking.value || isStartingActivity.value) return;

    isStartingActivity.value = true;

    try {
      if (!(await _requestPermissions())) return;
      _resetUiState();

      try {
        LatLng startPosition = await _locationService.getCurrentLocation();
        var response = await _recordActivityService.createSession(
          latitude: startPosition.latitude,
          longitude: startPosition.longitude,
          stamina: staminaToUse,
        );
        _recordActivityId = response['id'];
      } catch (e, s) {
        Get.back();
        Get.snackbar('Error', 'Failed to create activity session.');
        FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to create session');
        isStartingActivity.value = false;
        return;
      }

      totalStaminaToUse.value = staminaToUse;
      _startStaminaCountdown(staminaToUse: staminaToUse);

      // Fungsi initiateRecording sekarang menjadi Completer untuk ditunggu
      final completer = Completer<void>();

      void initiateRecording() {
        _service.invoke('startRecording');
        isTracking.value = true;
        _startPaceUpdater();
        Get.snackbar("Activity Started", "Tracking is running in the background.");
        if (!completer.isCompleted) completer.complete();
      }

      var isRunning = await _service.isRunning();
      if (isRunning) {
        // Jika service sudah berjalan (misalnya dari aktivitas sebelumnya yang tidak ditutup),
        // berarti ia sudah siap. Langsung kirim perintah.
        _logService.log.i("Service already running. Sending 'startRecording' command.");
        initiateRecording();
      } else {
        // Jika service belum berjalan, kita harus memulainya DAN menunggu sinyal 'service_ready'
        _logService.log.i("Service not running. Starting service and waiting for 'ready' signal...");
        
        // Siapkan listener satu kali untuk menangkap sinyal 'service_ready'
        // .take(1) memastikan listener ini hanya berjalan sekali lalu otomatis berhenti.
        _service.on('service_ready').take(1).listen((event) {
          _logService.log.i("UI LOG: 'service_ready' signal received. Sending 'startRecording' command.");
          initiateRecording();
        });

        // Baru setelah listener siap, kita mulai service-nya.
        await _service.startService();
      }

      // Tunggu hingga proses initiateRecording selesai
      await completer.future;
    } catch (e) {
      // Tangani error umum jika ada
      Get.snackbar('Error', 'An unexpected error occurred while starting.');
      _logService.log.e('An unexpected error occurred while starting.', error: e);
    } finally {
      isStartingActivity.value = false;
    }
  }

  void checkBeforeStopActivity() async {
    if (!isPaused.value) togglePauseResume();

    if (currentPath.isEmpty || currentPath.length < 2) {
      return Get.dialog(
        CustomDialogConfirmation(
          title: 'Insufficient Location Data',
          subtitle: 'Your activity has insufficient location data. Do you want to delete the activity?',
          labelConfirm: 'Yes, delete',
          onConfirm: () {
            deleteActivity();
            Get.back(closeOverlays: true);
          },
          onCancel: () => Get.back(),
        )
      );
    } else {
      stopActivity();
    }
  }

  void stopActivity() async {
    _logService.log.i("Attempting to stop and sync activity.");

    if (!isTracking.value) return;

    isLoadingSaveRecordActivity.value = true;
    isTracking.value = false;

    _staminaTimer?.cancel();
    _paceUpdateTimer?.cancel();

    Get.snackbar("Syncing", "Finalizing your activity...");

    _service.invoke("stopRecording");

    try {
      await _syncActivityData();

      final recordActivityData = await _recordActivityService.endSession(recordActivityId: _recordActivityId!);
      if (recordActivityData.id?.isNotEmpty ?? false) {
        await _localDb.clearAllUnsyncedData();
        Get.offAndToNamed(AppRoutes.activityEdit, arguments: recordActivityData);
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to sync/end session');
      Get.snackbar("Error", "An error occurred. Your progress is saved locally.");
    } finally {
      isLoadingSaveRecordActivity.value = false;
    }
  }

  void deleteActivity() async {
    final service = FlutterBackgroundService();
    service.invoke("stopRecording");
    await _localDb.clearAllUnsyncedData();
  }

  void _resetUiState() {
    elapsedTimeInSeconds.value = 0;
    stepsInSession.value = 0;
    currentDistanceInMeters.value = 0.0;
    currentPath.clear();
    isPaused.value = false;
    formattedPace.value = "00:00";
    _recordActivityId = null;
  }

  Future<void> _saveDataPointToLocalDb(Map<String, dynamic> loc, DateTime timestamp) async {
    double paceInSecondsPerKm = 0;
    if (elapsedTimeInSeconds.value > 0 && currentDistanceInMeters.value > 0) {
      paceInSecondsPerKm = (elapsedTimeInSeconds.value / currentDistanceInMeters.value) * 1000;
    }
    final dataPoint = ActivityDataPoint(
      latitude: loc['latitude'],
      longitude: loc['longitude'],
      step: stepsInSession.value,
      distance: currentDistanceInMeters.value,
      pace: paceInSecondsPerKm,
      time: elapsedTimeInSeconds.value,
      timestamp: timestamp,
    );

    await _localDb.addDataPoint(dataPoint);

    if ((currentDistanceInMeters.value / 1000) >= _nextSyncDistanceInKm && !isSyncing.value) {
      await _checkDistanceForPeriodicSync();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    _updateCameraForRoute();
  }

  void _updateCameraForRoute() {
    if (mapController == null || currentPath.isEmpty) return; // Cukup 1 titik untuk fokus awal

    final List<LatLng> points = currentPath.map((p) => LatLng(p.latitude, p.longitude)).toList();

    if (points.length == 1) {
      // ✨ PENYEMPURNAAN 1: Jika hanya ada satu titik, cukup pindahkan kamera ke sana
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(points.first, 17.0)); // Zoom 17
    } else {
      // Logika bounds Anda yang sudah ada
      double minLat = points.first.latitude,
        minLng = points.first.longitude,
        maxLat = points.first.latitude,
        maxLng = points.first.longitude;

      for (var point in points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      // ✨ PENYEMPURNAAN 2: Cek jika semua titik terlalu berdekatan (bounds tidak punya area)
      if (minLat == maxLat && minLng == maxLng) {
        // Jika semua titik sama, perlakukan seperti hanya ada satu titik
        mapController?.animateCamera(CameraUpdate.newLatLngZoom(points.first, 17.0));
        return;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60.0), // Tambah sedikit padding
      );
    }
  }

  void _startStaminaCountdown({required int staminaToUse}) {
    _logService.log.i("Starting stamina countdown. Total: $staminaToUse stamina.");

    _staminaTimer?.cancel(); // Batalkan timer lama jika ada

    if (staminaToUse <= 0) return;

    // 1. Set state awal berdasarkan total stamina yang dipilih
    totalStaminaToUse.value = staminaToUse;
    staminaRemainingCount.value = staminaToUse;
    // Hitung TOTAL waktu untuk semua stamina
    staminaTotalTimeRemainingInSeconds.value = staminaToUse * 3 * 60; 

    _staminaTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Countdown hanya berjalan jika tracking aktif dan tidak di-pause
      if (!isTracking.value) return;

      // Selalu kurangi total sisa waktu
      staminaTotalTimeRemainingInSeconds.value--;

      // 2. Logika baru untuk mengurangi jumlah stamina
      // Cek apakah sisa waktu adalah kelipatan dari waktu per stamina (3 menit)
      // Ini menandakan satu blok stamina telah selesai.
      if (staminaTotalTimeRemainingInSeconds.value % (3 * 60) == 0 &&
          staminaTotalTimeRemainingInSeconds.value > 0) {
        staminaRemainingCount.value--;
      }
      
      // 3. Logika akhir saat semua waktu habis
      if (staminaTotalTimeRemainingInSeconds.value <= 0) {
        staminaRemainingCount.value = 0; // Pastikan sisa stamina 0
        timer.cancel();
        Get.snackbar("Stamina Depleted", "All stamina has been used.");
      }
    });
  }

  // ✨ Getter untuk memformat sisa waktu stamina ke "MM:SS"
  String get formattedStaminaTime {
    final int minutes = staminaTotalTimeRemainingInSeconds.value ~/ 60;
    final int seconds = staminaTotalTimeRemainingInSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String get formattedElapsedTime {
    final int hours = elapsedTimeInSeconds.value ~/ 3600;
    final int minutes = (elapsedTimeInSeconds.value % 3600) ~/ 60;
    final int seconds = elapsedTimeInSeconds.value % 60;

    // Format MM:SS (Menit:Detik) yang lebih umum untuk lari
    // Jika lebih dari 1 jam, akan menampilkan jam juga (JJ:MM:SS)
    if (hours > 0) {
      return "${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  void _startPaceUpdater() {
    // Batalkan timer lama jika ada untuk menghindari duplikasi
    _paceUpdateTimer?.cancel();
    
    _paceUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Setiap 3 detik, perbarui state 'formattedPace' 
      // dengan nilai dari kalkulasi saat ini.
      formattedPace.value = _calculateCurrentPace();
    });
  }

  void _triggerCoinAnimation() {
    // 1. Batalkan timer lama jika masih berjalan, agar timer di-reset
    _coinAnimationTimer?.cancel();
    
    // 2. Tampilkan widget animasi
    showCoinAnimation.value = true;
    
    // 3. Mulai timer baru selama 5 detik untuk menyembunyikannya kembali
    _coinAnimationTimer = Timer(const Duration(seconds: 5), () {
      showCoinAnimation.value = false;
    });
  }

  // ✨ Getter yang lama diubah menjadi fungsi kalkulasi privat
  String _calculateCurrentPace() {
    if (currentDistanceInMeters.value < 10 || elapsedTimeInSeconds.value == 0) {
      return "00:00"; 
    }
    double distanceInKm = currentDistanceInMeters.value / 1000;
    double timeInMinutes = elapsedTimeInSeconds.value / 60;
    double paceInMinutesPerKm = timeInMinutes / distanceInKm;
    final int paceMinutes = paceInMinutesPerKm.truncate();
    final int paceSeconds = ((paceInMinutesPerKm - paceMinutes) * 60).round();
    return "${paceMinutes.toString().padLeft(2, '0')}:${paceSeconds.toString().padLeft(2, '0')}";
  }

  String get distance {
    double distanceInKm = currentDistanceInMeters.value / 1000;
    return "${distanceInKm.toStringAsFixed(2)} km";
  }

  Set<Polyline> get activityPolylines {
    // Jika path masih kosong, kembalikan set kosong
    if (currentPath.isEmpty) {
      return <Polyline>{};
    }

    // Buat satu Polyline dengan ID unik
    return {
      Polyline(
        polylineId: const PolylineId('activity_path'),
        color: darkColorScheme.primary,
        width: 4,
        startCap: Cap.buttCap,
        endCap: Cap.buttCap,
        points: currentPath
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(),
      ),
    };
  }
}