import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';

class StartActivityController extends GetxController {
  Rxn<LatLng> currentPosition = Rxn<LatLng>();

  final _locationService = sl<LocationService>();

  final AuthService _authService = sl<AuthService>();
  UserModel? get user => _authService.user;

  RxBool isLoadingGetUserData = false.obs;

  @override
  void onInit() {
    super.onInit();
    setCurrentLocation();
    _loadMe();
  }

  Future<void> setCurrentLocation() async {
    if (!await _requestPermissions()) return;
    currentPosition.value = await _locationService.getCurrentLocation();
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

    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      Get.snackbar("Layanan Lokasi Mati", "Mohon aktifkan layanan lokasi.");
      return false;
    }
    return true;
  }

  Future<void> _loadMe() async {
    isLoadingGetUserData.value = true;

    try {
      final user = await sl<AuthService>().me();
    } catch (e) {
      rethrow;
    } finally {
      isLoadingGetUserData.value = false;
    }
  }

  String get formattedStaminaTime {
    int staminaTotalTimeRemainingInSeconds = (user?.currentUserStamina?.currentAmount ?? 0) * 3 * 60;
    final int minutes = staminaTotalTimeRemainingInSeconds ~/ 60;
    final int seconds = staminaTotalTimeRemainingInSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}