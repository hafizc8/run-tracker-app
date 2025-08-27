import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/update_club_form.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/controllers/detail_club_controller.dart';

class UpdateClubController extends GetxController {
  final String clubId;
  UpdateClubController({required this.clubId});

  TextEditingController cityController = TextEditingController();
  final LocationService _locationService = sl<LocationService>();
  RxBool isLoading = false.obs;
  RxBool isLoadingGetCurrentLocation = false.obs;
  RxBool isLoadingLoadData = false.obs;
  final ClubService _clubService = sl<ClubService>();

  var updateClubForm = UpdateClubFormModel().obs;
  var updateClubOriginalForm = UpdateClubFormModel().obs;

  bool get isValidToUpdate => updateClubOriginalForm.value.isValidToUpdate(updateClubForm.value);

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<File?> getCachedImageFile(String imageUrl) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
    return fileInfo?.file;
  }

  dynamic getData() async {
    isLoadingLoadData.value = true;
    ClubModel res = await _clubService.getDetail(clubId: clubId);
    updateClubForm.value = UpdateClubFormModel(
      id: res.id,
      name: res.name,
      description: res.description,
      city: res.district,
      clubPrivacy: res.privacy,
      postPermission: res.postPermission,
    );

    cityController.text = res.district ?? '';

    if (res.imageUrl != null) {
      getCachedImageFile(res.imageUrl ?? '').then((value) {
        updateClubForm.value = updateClubForm.value.copyWith(image: value);
      }).onError((error, stackTrace) {
        updateClubForm.value = updateClubForm.value.copyWith(image: null);
      });
    }

    updateClubOriginalForm.value = updateClubForm.value;

    isLoadingLoadData.value = false;
  }

  Future<void> getOnlyCity({required LatLng latLng}) async {
    cityController.text = (await _locationService.getCityFromLatLng(latLng)).replaceAll('Kota', '');
    updateClubForm.value = updateClubForm.value.copyWith(city: cityController.text);
  }

  dynamic pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      try {
        updateClubForm.value = updateClubForm.value.copyWith(image: File(result.path));
      } catch (e) {
        print("Error correcting image orientation: $e");
        Get.snackbar('Error', 'Gagal mengambil file: ${e.toString()}');
      }
    }
  }

  Future<void> updateClub(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    updateClubForm.value = updateClubForm.value.clearErrors();
    try {
      bool resp = await _clubService.update(clubId: updateClubForm.value.id!, form: updateClubForm.value);
      if (resp) {
        // refresh
        Get.find<DetailClubController>().loadDetail();

        Get.back(closeOverlays: true);
        Get.snackbar("Success", "Successfully update club");
      }
    } on AppException catch (e) {
      if (e.type == AppExceptionType.validation) {
        updateClubForm.value = updateClubForm.value.setErrors(e.errors!);
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