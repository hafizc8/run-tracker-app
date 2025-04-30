import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/location_model.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';

class ChooseLocationController extends GetxController {
  final _locationService = sl<LocationService>();
  var isLoading = false.obs;
  final currentPosition =
      const LatLng(-6.2615, 106.8106).obs; // Default Jakarta
  Rxn<LatLng> lastLatLng = Rxn<LatLng>();
  GoogleMapController? mapController;

  final RxString address = ''.obs;

  late final CameraPosition initialPosition;

  Timer? _debounce;
  bool allowReverseGeocode = false;

  bool get canUpdate => address.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    initialPosition = CameraPosition(
      target: currentPosition.value, // Default Jakarta,
      zoom: 16,
    );

    var args = Get.arguments;
    if (args != null) {
      if (args['lat'] != null && args['lng'] != null) {
        currentPosition.value = LatLng(args['lat'], args['lng']);
      }

      if (args['address'] != null) {
        address.value = args['address'];
      }
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  Future<void> setMarkerAndMoveCamera(LatLng position) async {
    if (isClosed) return;
    currentPosition.value = position;
    mapController?.animateCamera(CameraUpdate.newLatLng(currentPosition.value));
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
    final newLatLng = currentPosition.value;
    final oldLatLng = lastLatLng.value;

    if (oldLatLng != null) {
      final distance = Geolocator.distanceBetween(
        oldLatLng.latitude,
        oldLatLng.longitude,
        newLatLng.latitude,
        newLatLng.longitude,
      );

      if (distance < 50) {
        // Gak usah fetch, cuma geser sedikit

        return;
      }
    }

    isLoading.value = true;
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      allowReverseGeocode = false;
      lastLatLng.value = newLatLng;
      await _getAddressFromLatLng(currentPosition.value);
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
    return null;
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
    try {
      address.value = await _locationService.getAddressFromLatLng(latLng);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
