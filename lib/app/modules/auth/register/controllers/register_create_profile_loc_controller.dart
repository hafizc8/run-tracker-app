import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/location_model.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';

class RegisterCreateProfileLocController extends GetxController {
  final _locationService = sl<LocationService>();
  var isLoading = false.obs;
  final currentPosition =
      const LatLng(-6.2088, 106.8456).obs; // Default Jakarta
  GoogleMapController? mapController;

  final RxString address = ''.obs;

  late final CameraPosition initialPosition;

  Timer? _debounce;
  bool allowReverseGeocode = false;

  bool get canUpdate => address.value.isNotEmpty;

  @override
  void onInit() {
    var args = Get.arguments;
    if (args != null) {
      if (args['lat'] != null && args['lng'] != null) {
        currentPosition.value = LatLng(args['lat'], args['lng']);
      }

      if (args['address'] != null) {
        address.value = args['address'];
      }
    }
    initialPosition = CameraPosition(
      target: currentPosition.value, // Default Jakarta,
      zoom: 16,
    );
    super.onInit();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  Future<void> setMarkerAndMoveCamera(LatLng position) async {
    if (isClosed) return;
    currentPosition.value = position;
    mapController
        ?.animateCamera(CameraUpdate.newLatLng(currentPosition.value!));
  }

  Future<void> setCurrentLocation() async {
    LatLng latLng = await _locationService.getCurrentLocation();
    await setMarkerAndMoveCamera(latLng);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onCameraMoveStarted() {
    allowReverseGeocode = true;
  }

  void onCameraMove(CameraPosition position) {
    currentPosition.value = position.target;
  }

  void onCameraIdle() async {
    if (!allowReverseGeocode) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), () async {
      allowReverseGeocode = false;
      await _getAddressFromLatLng(currentPosition.value!);
    });
  }

  Future<List<LocationModel>?> searchPlace(String query) async {
    try {
      return await _locationService.searchPlace(query);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Fungsi untuk memilih lokasi dari hasil pencarian
  Future<void> selectPlace(String placeId) async {
    try {
      LatLng latLng = await _locationService.selectPlace(placeId);

      await setMarkerAndMoveCamera(latLng);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Mengambil alamat dari latLng (reverse geocoding)
  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    isLoading.value = true;
    try {
      address.value = await _locationService.getAddressFromLatLng(latLng);
      isLoading.value = false;
    } on AppException catch (e) {
      isLoading.value = false;
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
