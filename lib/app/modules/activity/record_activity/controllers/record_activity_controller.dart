import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
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

  @override
  void onClose() {
    stopActivity();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    FlutterBackgroundService().on('update').listen((data) {
      if (data == null) return;
      
      isTracking.value = true;
      elapsedTimeInSeconds.value = data['elapsedTime'];
      stepsInSession.value = data['steps'];
      currentDistanceInMeters.value = double.parse(data['distance'].toString());

      // ✨ DIUBAH: Terima titik lokasi baru dari service
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

    startActivity();
  }

  void togglePauseResume() {
    final service = FlutterBackgroundService();
    if (isPaused.value) {
      // Jika sedang pause, kirim event 'resume'
      service.invoke('resume');
      Get.snackbar("Aktivitas Dilanjutkan", "Pelacakan kembali aktif.");
    } else {
      // Jika sedang berjalan, kirim event 'pause'
      service.invoke('pause');
      Get.snackbar("Aktivitas Dijeda", "Pelacakan dijeda untuk sementara.");
    }
    // Balikkan nilai state di UI
    isPaused.value = !isPaused.value;
  }

  Future<bool> _requestPermissions() async {
    var activityStatus = await Permission.activityRecognition.request();
    if (!activityStatus.isGranted) {
      Get.snackbar("Izin Ditolak", "Izin sensor aktivitas diperlukan.");
      return false;
    }

    var locationStatus = await Permission.locationWhenInUse.request();
    if (!locationStatus.isGranted) {
      Get.snackbar("Izin Ditolak", "Izin lokasi diperlukan.");
      return false;
    }
    return true;
  }

  Future<void> startActivity() async {
    FirebaseCrashlytics.instance.log("Attempting to create session.");
    bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) return;

    // Reset state di UI
    elapsedTimeInSeconds.value = 0;
    stepsInSession.value = 0;
    currentDistanceInMeters.value = 0.0;
    currentPath.clear();

    try {
      LatLng startPosition = await _locationService.getCurrentLocation();
      var response = await _recordActivityService.createSession(latitude: startPosition.latitude, longitude: startPosition.longitude, stamina: 0);
      _recordActivityId = response['id'];
      FirebaseCrashlytics.instance.log("Session created successfully with ID: $_recordActivityId");
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to create activity session. Please try again.');
      return;
    }

    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      service.startService();
    }
    
    isTracking.value = true;
    Get.snackbar("Aktivitas Dimulai", "Pelacakan berjalan di latar belakang.");
  }

  void stopActivity() async {
    if (isPaused.value) {
      togglePauseResume(); 
      // Beri sedikit waktu untuk service memproses resume sebelum stop
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final service = FlutterBackgroundService();
    service.invoke("stopService");
    isTracking.value = false;
    Get.snackbar("Aktivitas Selesai", "Pelacakan dihentikan.");

    Get.snackbar("Sinkronisasi...", "Mengirim data aktivitas ke server.");

    try {
      // LANGKAH 2: SYNC RECORD ACTIVITY
      final dataPoints = await _localDb.getAllDataPoints();
      if (dataPoints.isEmpty) {
        Get.snackbar("Info", "Tidak ada data untuk disinkronkan.");
        return;
      }

      final jsonData = dataPoints.map((p) => p.toJson()).toList();

      bool syncSuccess = await _recordActivityService.syncRecordActivity(
        recordActivityId: _recordActivityId!,
        data: jsonData,
      );

      if (syncSuccess) {
        // LANGKAH 3: END SESSION
        final recordActivityData = await _recordActivityService.endSession(recordActivityId: _recordActivityId!);
        
        if (recordActivityData.id?.isNotEmpty ?? false) {
          await _localDb.clearDataPoints();
          Get.snackbar("Berhasil", "Aktivitas berhasil direkam dan disinkronkan!");

          // redirect to edit activity
          Get.offAndToNamed(AppRoutes.activityEdit, arguments: recordActivityData);
        } else {
          Get.snackbar("Gagal", "Gagal mengakhiri sesi di server. Data masih tersimpan lokal.");
        }
      } else {
        Get.snackbar("Gagal Sinkronisasi", "Data gagal dikirim, akan dicoba lagi nanti.");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan saat sinkronisasi: $e");
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
        startCap: Cap.roundCap, // Membuat ujung awal garis membulat
        endCap: Cap.roundCap,   // Membuat ujung akhir garis membulat
        points: currentPath
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(), // Konversi List<LocationPoint> menjadi List<LatLng>
      ),
    };
  }
}