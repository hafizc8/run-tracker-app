import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/registe_create_profile_form.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RegisterCreateProfileController extends GetxController {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  Rx<RegisterCreateProfileFormModel> form =
      RegisterCreateProfileFormModel().obs;
  var isLoading = false.obs;
  final _authService = sl<AuthService>();

  bool get isValid => form.value.isValid;

  Future<void> completeProfile(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    form.value = form.value.clearErrors();
    try {
      bool resp = await _authService.completeProfile(
        form.value,
      );
      if (resp) Get.offAllNamed(AppRoutes.registerSuccess);

      isLoading.value = false;
    } on AppException catch (e) {
      isLoading.value = false;
      if (e.type == AppExceptionType.validation) {
        form.value = form.value.setErrors(e.errors!);
        return;
      }
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> setDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      form.value = form.value.copyWith(birthday: picked.toYyyyMmDdString());
      dateController.text = picked.toYyyyMmDdString();
    }
  }
}
