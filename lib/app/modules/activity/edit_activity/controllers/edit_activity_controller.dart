import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:zest_mobile/app/modules/home/controllers/main_home_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/controllers/main_profile_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/custom_tab_bar/controllers/custom_tab_bar_controller.dart';
import 'dart:ui' as ui;

import 'package:zest_mobile/app/routes/app_routes.dart';

class EditActivityController extends GetxController {
  final RecordActivityModel recordActivityData;

  EditActivityController({required this.recordActivityData});

  RxBool isLoadingLoadEditActivity = false.obs;
  RxBool isLoadingSaveRecordActivity = false.obs;
  var editActivityForm = EditActivityForm().obs;

  var currentPath = <LocationPoint>[].obs;
  GoogleMapController? mapController;
  File? galleryMap;

  final PostService _postService = sl<PostService>();

  BitmapDescriptor startIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endIcon = BitmapDescriptor.defaultMarker;

  @override
  void onInit() {
    super.onInit();
    loadMarkerIcons(); 
    loadActivityData();
  }

  void loadMarkerIcons() {
    // Buat pin merah untuk titik start
    startIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    
    // Buat pin hijau untuk titik finish
    endIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    
    // Panggil update() untuk memberitahu GetX agar membangun ulang UI
    // yang bergantung pada ikon ini (misalnya, GoogleMap).
    update(); 
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

  Future<BitmapDescriptor> _getMarkerIconFromAsset(String path, {int width = 60}) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedBytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedBytes);
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

  dynamic pickMultipleMedia() async {
    ImagePicker picker = ImagePicker();
    List<XFile> result = await picker.pickMultiImage(
      limit: 5,
    );

    if (result.isNotEmpty) {
      try {
        List<File> correctedFiles = [];
        
        for (final xFile in result) {
          final File originalFile = File(xFile.path);
          correctedFiles.add(originalFile);
        }

        editActivityForm.value = editActivityForm.value.copyWith(
          newGalleries: correctedFiles
        );
      } catch (e) {
        print("Error correcting image orientation: $e");
        Get.snackbar('Error', 'Gagal mengambil file: ${e.toString()}');
      }
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
      galleryMap = await _captureMapSnapshot();

      editActivityForm.value = editActivityForm.value.copyWith(
        latitude: currentPath.first.latitude,
        longitude: currentPath.first.longitude,
        galleryMap: galleryMap,
      );

      bool isSuccess = await _postService.shareRecordActivity(editActivityForm.value);

      if (isSuccess) {
        // Kembali ke halaman utama dan menuju tab profile
        Get.until((route) => route.settings.name == AppRoutes.mainHome);
        if (Get.isRegistered<MainHomeController>()) {
          Get.find<MainHomeController>().changeTab(3); // change to menu profile
        }
        if (Get.isRegistered<ProfileMainController>()) {
          Get.find<ProfileMainController>().getPostActivity(refresh: true);
        }
        if (Get.isRegistered<TabBarController>()) {
          Get.find<TabBarController>().changeTabIndex(0); // change to tab overview
        }

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
      print(e.toString());
      Get.snackbar('Error', e.toString());
    }
    finally {
      isLoadingSaveRecordActivity.value = false;
    }
  }

  Set<Polyline> get activityPolylines {
    if (currentPath.isEmpty) return <Polyline>{};
    return {
      Polyline(
        polylineId: const PolylineId('activity_path'),
        color: darkColorScheme.primary,
        width: 5,
        startCap: Cap.buttCap,
        endCap: Cap.buttCap,
        points: currentPath.map((point) => LatLng(point.latitude, point.longitude)).toList(),
      ),
    };
  }

  Future<File?> _captureMapSnapshot() async {
    if (mapController == null) {
      print("Map controller is not ready.");
      return null;
    }

    try {
      // 1. Ambil snapshot dari peta. Hasilnya adalah Uint8List (data byte gambar).
      final Uint8List? imageBytes = await mapController!.takeSnapshot();

      if (imageBytes == null) {
        print("Failed to take snapshot.");
        return null;
      }
      
      // 2. Simpan data byte ke dalam file sementara
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/map_snapshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final File imageFile = File(path);
      await imageFile.writeAsBytes(imageBytes);

      print("Map snapshot saved to: ${imageFile.path}");
      return imageFile;
      
    } catch (e) {
      print("Error capturing map snapshot: $e");
      return null;
    }
  }
}