import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_club_form.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class CreateClubController extends GetxController {
  Rx<CreateClubFormModel> form = CreateClubFormModel().obs;
  TextEditingController cityController = TextEditingController();
  final LocationService _locationService = sl<LocationService>();
  RxBool isLoading = false.obs;
  RxBool isLoadingGetCurrentLocation = false.obs;
  final ClubService _clubService = sl<ClubService>();

  @override
  void onInit() {
    super.onInit();
    setCurrentLocation();
  }

  Future<void> setCurrentLocation() async {
    isLoadingGetCurrentLocation.value = true;
    LatLng latLng = await _locationService.getCurrentLocation();
    form.value = form.value.copyWith(latitude: latLng.latitude, longitude: latLng.longitude);
    await getOnlyCity(latLng: latLng);
    isLoadingGetCurrentLocation.value = false;
  }

  Future<void> getOnlyCity({required LatLng latLng}) async {
    cityController.text = (await _locationService.getCityFromLatLng(latLng)).replaceAll('Kota', '');
    form.value = form.value.copyWith(city: cityController.text);
  }

  dynamic pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      form.value = form.value.copyWith(image: File(result.files.single.path!));
    }
  }

  Future<void> createClub(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    form.value = form.value.clearErrors();
    form.value = form.value.copyWith(city: cityController.text);

    try {
      ClubModel resp = await _clubService.create(form.value);

      Get.back(closeOverlays: true);
      Get.snackbar("Success", "Successfully create club");

      // go to detail club
      await Get.toNamed(AppRoutes.detailClub, arguments: resp.id);
    } on AppException catch (e) {
      if (e.type == AppExceptionType.validation) {
        form.value = form.value.setErrors(e.errors!);
        return;
      }
      
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}