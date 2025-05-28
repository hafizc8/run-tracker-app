import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/enums/gender_enum.dart';
import 'package:zest_mobile/app/core/models/forms/update_user_form.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';

class EditProfileController extends GetxController {
  var form = UpdateUserFormModel().obs;
  var dateController = TextEditingController();
  var addressController = TextEditingController();
  var isLoading = false.obs;
  var originalForm = UpdateUserFormModel().obs;
  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();

  late ImagePicker _imagePicker;

  bool get isValidToUpdate => originalForm.value.isValidToUpdate(form.value);

  void requestPermission() async {
    await Geolocator.requestPermission();
  }

  Future<File?> getCachedImageFile(String imageUrl) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
    return fileInfo?.file;
  }

  @override
  void onInit() {
    super.onInit();
    requestPermission();
    UserModel? user = _authService.user;
    _imagePicker = ImagePicker();
    if (user != null) {
      form.value = UpdateUserFormModel(
        name: user.name,
        email: user.email,
        gender: GenderEnum.fromValue(user.gender ?? 0).name,
        bio: user.bio,
        birthday: user.birthday,
        latitude: double.tryParse(user.latitude ?? '0.0'),
        longitude: double.tryParse(user.longitude ?? '0.0'),
        image: null,
      );
      getCachedImageFile(user.imageUrl ?? '').then((value) {
        form.value = form.value.copyWith(image: value);
        originalForm.value = form.value;
      }).onError((error, stackTrace) {
        form.value = form.value.copyWith(image: null);
      });

      dateController.text = user.birthday?.toYyyyMmDdString() ?? '';
      addressController.text = user.address;
      originalForm.value = form.value;
    }
  }

  Future<void> setDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: form.value.birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      form.value = form.value.copyWith(birthday: picked);
      dateController.text = picked.toYyyyMmDdString();
    }
  }

  Future<void> imagePicker(BuildContext context) async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Get.back();
                XFile? image = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  form.value = form.value.copyWith(image: File(image.path));
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.photo_library_outlined),
                  SizedBox(width: 8),
                  Text('Gallery'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                Get.back();
                XFile? image = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  form.value = form.value.copyWith(image: File(image.path));
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(width: 8),
                  Text('Camera'),
                ],
              ),
            ),
          ],
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  Future<void> updateProfile(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    form.value = form.value.clearErrors();
    try {
      bool resp = await _userService.editUser(form.value);
      if (resp) {
        var data = sl<StorageService>().read(StorageKeys.user);
        if (data != null) {
          Get.back(result: UserDetailModel.fromJson(data));
        }
      }
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
