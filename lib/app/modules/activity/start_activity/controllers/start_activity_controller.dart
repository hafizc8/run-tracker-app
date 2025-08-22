import 'dart:async';
// import 'package:disable_battery_optimization/disable_battery_optimization.dart';
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
    loadMe();
  }

  Future<void> setCurrentLocation() async {
    if (!await _requestPermissions()) return;
    currentPosition.value = await _locationService.getCurrentLocation();
  }

  Future<bool> _requestPermissions() async {
    if (!await Permission.activityRecognition.isGranted) {
      var activityStatus = await Permission.activityRecognition.request();
      if (!activityStatus.isGranted) {
        Get.snackbar("Permission Denied", "Activity sensor permission is required.");
        return false;
      }
    }

    if (!await Permission.locationWhenInUse.isGranted) {
      var locationStatus = await Permission.locationWhenInUse.request();
      if (!locationStatus.isGranted) {
        Get.snackbar("Permission Denied", "Location permission is required for activity tracking.");
        return false;
      }
    }

    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      Get.snackbar("Location Service Disabled", "Please enable location services for accurate tracking.");
      return false;
    }

    // bool? isBatteryOptimizationDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    // if (isBatteryOptimizationDisabled == false) {
    //   bool? isBatteryOptimizationDisabled = await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    //   if (isBatteryOptimizationDisabled == false) {
    //     Get.snackbar("Battery Optimizations Disabled", "Please enable battery optimizations for accurate tracking.");
    //     return false;
    //   }
    // }

    // bool? isManBatteryOptimizationDisabled = await DisableBatteryOptimization.isManufacturerBatteryOptimizationDisabled;
    // if (isManBatteryOptimizationDisabled == false) {
    //   bool? isManBatteryOptimizationDisabled = await DisableBatteryOptimization.showDisableManufacturerBatteryOptimizationSettings(
    //     "Your device has additional battery optimization",
    //     "Follow the steps and disable the optimizations to allow smooth functioning of this app",
    //   );
    //   if (isManBatteryOptimizationDisabled == false) {
    //     Get.snackbar("Manufacturer Battery Optimizations Disabled", "Please enable manufacturer battery optimizations for accurate tracking.");
    //     return false;
    //   }
    // }
    
    return true;
  }

  Future<void> loadMe() async {
    isLoadingGetUserData.value = true;

    try {
      await sl<AuthService>().me();
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