import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/edit_activity_form.dart';
import 'package:zest_mobile/app/core/models/model/location_point_model.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/models/model/record_activity_model.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class EditActivityController extends GetxController {
  final RecordActivityModel recordActivityData;

  EditActivityController({required this.recordActivityData});

  RxBool isLoadingLoadEditActivity = false.obs;
  RxBool isLoadingSaveRecordActivity = false.obs;
  var editActivityForm = EditActivityForm().obs;

  var currentPath = <LocationPoint>[].obs;
  GoogleMapController? mapController;

  final PostService _postService = sl<PostService>();

  @override
  void onInit() {
    super.onInit();

    loadActivityData();
  }

  dynamic loadActivityData() {
    editActivityForm.value = EditActivityForm(
      recordActivityId: recordActivityData.id,
    );

    currentPath.value = recordActivityData.recordActivityLogs.map((e) {
      return LocationPoint(
        latitude: e.latitude ?? 0.0,
        longitude: e.longitude ?? 0.0,
        timestamp: e.timestamp ?? DateTime.now(),
      );
    }).toList();
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

  dynamic pickMultipleMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );

    if (result != null) {
      editActivityForm.value = editActivityForm.value.copyWith(
        newGalleries: result.xFiles.map((e) => File(e.path)).toList(),
      );
    }
  }

  void removeMedia({
    required bool isFromServer,
    Gallery? gallery,
    File? file,
  }) {
    final updatedForm = editActivityForm.value;

    if (isFromServer && gallery != null) {
      // Hapus berdasarkan ID Gallery
      final newCurrentGalleries = (updatedForm.currentGalleries ?? [])
          .where((g) => g.id != gallery.id)
          .toList();

      final newDeletedGalleries =
          List<String>.from(updatedForm.deletedGalleries ?? [])
            ..add(gallery.id ?? '');

      editActivityForm.value = updatedForm.copyWith(
        currentGalleries: newCurrentGalleries,
        deletedGalleries: newDeletedGalleries,
      );
    } else if (!isFromServer && file != null) {
      // Hapus berdasarkan path file lokal
      final newNewGalleries = (updatedForm.newGalleries ?? [])
          .where((f) => f.path != file.path)
          .toList();

      editActivityForm.value = updatedForm.copyWith(
        newGalleries: newNewGalleries,
      );
    }
  }

  dynamic saveActivity() async {
    isLoadingSaveRecordActivity.value = true;

    try {
      editActivityForm.value = editActivityForm.value.copyWith(
        latitude: currentPath.first.latitude,
        longitude: currentPath.first.longitude,
      );

      bool isSuccess = await _postService.shareRecordActivity(editActivityForm.value);

      if (isSuccess) {
        Get.back(closeOverlays: true);
        Get.back(closeOverlays: true);
        Get.snackbar('Success', 'Successfully share activity');
      }
    } on AppException catch (e) {
      if (e.type == AppExceptionType.validation) {
        editActivityForm.value = editActivityForm.value.setErrors(e.errors!);
        return;
      }

      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } 
    catch (e) {
      Get.snackbar('Error', e.toString());
    }
    finally {
      isLoadingSaveRecordActivity.value = false;
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