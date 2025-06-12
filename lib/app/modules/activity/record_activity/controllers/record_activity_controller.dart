import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/activity_data_point_model.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';
import 'package:zest_mobile/app/core/services/local_activity_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/core/services/record_activity_service.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RecordActivityController extends GetxController {
  var isTracking = false.obs;
  var stepsInSession = 0.obs;
  var currentPath = <LocationPoint>[].obs;
  var currentDistanceInMeters = 0.0.obs;
  var elapsedTimeInSeconds = 0.obs;
  Rxn<LatLng> currentPosition = Rxn<LatLng>();
  RxBool isMapViewMode = false.obs;
  GoogleMapController? mapController;
  final _localDb = LocalActivityService();
  String? _recordActivityId;
  final RecordActivityService _recordActivityService = sl<RecordActivityService>();
  final _locationService = sl<LocationService>();
  var isPaused = false.obs;
  RxBool isLoadingSaveRecordActivity = false.obs;

  @override
  void onClose() {
    _closeActivity();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    _listenToBackgroundService();
    _initializeSession();
  }

  void _listenToBackgroundService() {
    FlutterBackgroundService().on('update').listen((data) {
      if (data == null) return;
      
      isTracking.value = true;
      elapsedTimeInSeconds.value = data['elapsedTime'];
      stepsInSession.value = data['steps'];
      currentDistanceInMeters.value = double.parse(data['distance'].toString());

      if (data['location'] != null) {
        final loc = data['location'];
        final newPoint = LocationPoint(
          latitude: loc['latitude'],
          longitude: loc['longitude'],
          timestamp: DateTime.parse(loc['timestamp']),
        );
        currentPath.add(newPoint);
        _updateCameraForRoute();
      }
    });
  }

  Future<void> _initializeSession() async {
    // Cek apakah ada sesi dan data point yang belum disinkronisasi
    final unsyncedSession = await _localDb.getUnsyncedSession();
    final unsyncedPoints = await _localDb.getAllDataPoints();

    if (unsyncedSession != null && unsyncedPoints.isNotEmpty) {
      // Jika ada, tampilkan dialog konfirmasi
      _showResumeOrDiscardDialog(unsyncedSession, unsyncedPoints);
    }  else {
      // Jika tidak ada, mulai aktivitas baru seperti biasa
      await startActivity();
    }
  }

  void _showResumeOrDiscardDialog(Map<String, dynamic> sessionData, List<ActivityDataPoint> points) {
    Get.dialog(
      AlertDialog(
        backgroundColor: darkColorScheme.background,
        title: Text("Unfinished Activity Found", style: Theme.of(Get.context!).textTheme.titleSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Text("You have an unsynced activity. Would you like to resume it or discard it and start a new one?", style: Theme.of(Get.context!).textTheme.titleSmall),
        actions: [
          TextButton(
            child: Text("DISCARD & START NEW", style: Theme.of(Get.context!).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              Get.back(); // Tutup dialog
              _discardAndStartNew();
            },
          ),
          ElevatedButton(
            child: Text("RESUME", style: Theme.of(Get.context!).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            onPressed: () {
              Get.back(); // Tutup dialog
              _resumeActivityFromLocal(sessionData, points);
            },
          ),
        ],
      ),
      barrierDismissible: false, // User harus memilih salah satu
    );
  }

  Future<void> _resumeActivityFromLocal(Map<String, dynamic> sessionData, List<ActivityDataPoint> points) async {
    // 1. Restore state dari data lokal
    _recordActivityId = sessionData['id'];
    elapsedTimeInSeconds.value = sessionData['elapsedTime'];
    stepsInSession.value = sessionData['steps'];
    currentDistanceInMeters.value = sessionData['distance'];
    currentPath.assignAll(
      points.map((loc) => LocationPoint(
          latitude: loc.latitude,
          longitude: loc.longitude,
          timestamp: loc.timestamp,
      )).toList()
    );

    // 2. Restart background service dengan state yang sudah dipulihkan
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
        // Jika service sudah jalan (misalnya dari sesi sebelumnya), panggil restoreState
        service.invoke('restoreState', {
          'elapsedTime': elapsedTimeInSeconds.value,
          'distance': currentDistanceInMeters.value,
          'steps': stepsInSession.value
        });
    } else {
        // Jika service belum jalan, mulai dulu
        await service.startService();
        // Beri sedikit jeda agar service siap sebelum mengirim event
        await Future.delayed(const Duration(milliseconds: 500));
        service.invoke('restoreState', {
          'elapsedTime': elapsedTimeInSeconds.value,
          'distance': currentDistanceInMeters.value,
          'steps': stepsInSession.value
        });
    }

    isTracking.value = true;
    isPaused.value = true; // Mulai dalam keadaan jeda
    
    Get.snackbar("Activity Resumed", "Tracking is paused. Press resume to continue.");

    // Update peta dengan rute yang sudah ada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCameraForRoute();
    });
  }

  Future<void> _discardAndStartNew() async {
    // Hapus data lama dari database lokal
    await _localDb.clearAllUnsyncedData();

    // Reset UI dan state
    isTracking.value = false;
    isPaused.value = false;
    elapsedTimeInSeconds.value = 0;
    stepsInSession.value = 0;
    currentDistanceInMeters.value = 0.0;
    currentPath.clear();
    _recordActivityId = null;
    
    // Mulai aktivitas baru
    await startActivity();
  }

  void togglePauseResume() {
    final service = FlutterBackgroundService();
    if (isPaused.value) {
      service.invoke('resume');
      Get.snackbar("Activity Resumed", "Tracking is active again.");
    } else {
      service.invoke('pause');
      Get.snackbar("Activity Paused", "Tracking is temporarily paused.");
    }

    isPaused.value = !isPaused.value;
  }

  Future<bool> _requestPermissions() async {
    var activityStatus = await Permission.activityRecognition.request();
    if (!activityStatus.isGranted) {
      Get.snackbar("Permission Denied", "Activity sensor permission is required.");
      return false;
    }

    var locationStatus = await Permission.locationWhenInUse.request();
    if (!locationStatus.isGranted) {
      Get.snackbar("Permission Denied", "Location permission is required.");
      return false;
    }
    return true;
  }

  Future<void> startActivity() async {
    bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) return;

    // Reset state di UI
    elapsedTimeInSeconds.value = 0;
    stepsInSession.value = 0;
    currentDistanceInMeters.value = 0.0;
    currentPath.clear();
    isPaused.value = false;

    try {
      LatLng startPosition = await _locationService.getCurrentLocation();
      var response = await _recordActivityService.createSession(latitude: startPosition.latitude, longitude: startPosition.longitude, stamina: 0);
      _recordActivityId = response['id'];

      // PENTING: Simpan ID sesi dan state awal ke local DB
      await _localDb.saveUnsyncedSession({
        'id': _recordActivityId,
        'elapsedTime': 0,
        'distance': 0.0,
        'steps': 0,
      });

    } catch (e, s) {
      Get.back();
      Get.snackbar('Error', 'Failed to create activity session. Please try again.');
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to create session');
      return;
    }

    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      service.startService();
    }
    
    isTracking.value = true;
    Get.snackbar("Activity Started", "Tracking is running in the background.");
  }

  void stopActivity() async {
    isLoadingSaveRecordActivity.value = true;

    final service = FlutterBackgroundService();
    service.invoke("stopService");
    isTracking.value = false;

    Get.snackbar("Syncing", "Synchronizing activity data...");

    try {
      final dataPoints = await _localDb.getAllDataPoints();
      if (dataPoints.isEmpty) {
        // Jika tidak ada data point tapi ada sesi, coba akhiri saja
        if (_recordActivityId != null) {
          final recordActivityData = await _recordActivityService.endSession(recordActivityId: _recordActivityId!);
          if (recordActivityData.id?.isNotEmpty ?? false) {
              await _localDb.clearAllUnsyncedData(); // Hapus sesi yg tersimpan
              Get.offAndToNamed(AppRoutes.activityEdit, arguments: recordActivityData);
              return; // Keluar dari fungsi setelah berhasil
          }
        }
        
        Get.snackbar("Info", "No data to sync.");
        isLoadingSaveRecordActivity.value = false;
        return;
      }

      final jsonData = dataPoints.map((p) => p.toJson()).toList();
      bool syncSuccess = await _recordActivityService.syncRecordActivity(
        recordActivityId: _recordActivityId!,
        data: jsonData,
      );

      if (syncSuccess) {
        final recordActivityData = await _recordActivityService.endSession(recordActivityId: _recordActivityId!);
        
        if (recordActivityData.id?.isNotEmpty ?? false) {
          await _localDb.clearAllUnsyncedData();
          Get.offAndToNamed(AppRoutes.activityEdit, arguments: recordActivityData);
        } else {
          Get.snackbar("Failed", "Failed to end activity session.");
        }
      } else {
        Get.snackbar("Failed", "Failed to sync activity data.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to sync activity data: $e");
    } finally {
      isLoadingSaveRecordActivity.value = false;
    }
  }

  void deleteActivity() async {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
    await _localDb.clearAllUnsyncedData();
  }

  void _closeActivity() async {
    print('Save activity closed');
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
      await _localDb.saveUnsyncedSession({
        'id': _recordActivityId,
        'elapsedTime': elapsedTimeInSeconds.value,
        'distance': currentDistanceInMeters.value,
        'steps': stepsInSession.value,
      });
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
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(points.first, 17.0)); // Zoom 17
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
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(points.first, 17.0));
        return;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60.0), // Tambah sedikit padding
      );
    }
}

  // Helper untuk format jarak (bisa dipindah ke file util terpisah)
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} m";
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return "${distanceInKm.toStringAsFixed(2)} km";
    }
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

  String get formattedPace {
    if (currentDistanceInMeters.value < 10 || elapsedTimeInSeconds.value == 0) {
      // Jika jarak terlalu pendek atau waktu masih nol, pace belum bisa dihitung
      return "00:00"; 
    }

    // 1. Ubah jarak ke kilometer
    double distanceInKm = currentDistanceInMeters.value / 1000;
    // 2. Ubah waktu ke menit (dalam bentuk desimal)
    double timeInMinutes = elapsedTimeInSeconds.value / 60;
    // 3. Hitung pace (menit per km)
    double paceInMinutesPerKm = timeInMinutes / distanceInKm;

    // 4. Pisahkan bagian menit dan detik dari pace
    final int paceMinutes = paceInMinutesPerKm.truncate();
    final int paceSeconds = ((paceInMinutesPerKm - paceMinutes) * 60).round();

    return "${paceMinutes.toString().padLeft(2, '0')}:${paceSeconds.toString().padLeft(2, '0')}";
  }

  String get distance {
    if (currentDistanceInMeters.value < 1000) {
      return "${currentDistanceInMeters.value.toStringAsFixed(0)} m";
    } else {
      double distanceInKm = currentDistanceInMeters.value / 1000;
      return "${distanceInKm.toStringAsFixed(2)} km";
    }
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
        color: darkColorScheme.primary, // Anda bisa sesuaikan warnanya
        width: 5, // Anda bisa sesuaikan ketebalan garis
        startCap: Cap.buttCap,
        endCap: Cap.buttCap,
        points: currentPath
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(), // Konversi List<LocationPoint> menjadi List<LatLng>
      ),
    };
  }
}