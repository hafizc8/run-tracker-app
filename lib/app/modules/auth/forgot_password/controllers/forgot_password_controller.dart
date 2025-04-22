import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/forgot_password_form.dart';
import 'package:zest_mobile/app/core/models/forms/reset_password_form.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  Rx<ForgotPasswordFormModel> form = ForgotPasswordFormModel().obs;
  Rx<ResetPasswordFormModel> formReset = ResetPasswordFormModel().obs;
  var isLoading = false.obs;
  final _authService = sl<AuthService>();

  var isVisiblePassword = true.obs;
  var isVisiblePasswordConfirmation = true.obs;

  @override
  void onReady() {
    var args = Get.arguments;
    formReset.value = formReset.value
        .copyWith(email: args?['email'] ?? '', token: args?['token'] ?? '');
    super.onReady();
  }

  Future<void> forgotPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    form.value = form.value.clearErrors();
    try {
      bool resp = await _authService.forgotPassword(
        form.value,
      );
      if (resp) Get.offAllNamed(AppRoutes.forgotPasswordEmailSent);

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

  Future<void> resetPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    form.value = form.value.clearErrors();
    try {
      bool resp = await _authService.resetPassword(
        formReset.value,
      );
      if (resp) Get.offAllNamed(AppRoutes.forgotPasswordUpdated);

      isLoading.value = false;
    } on AppException catch (e) {
      isLoading.value = false;
      if (e.type == AppExceptionType.validation) {
        formReset.value = formReset.value.setErrors(e.errors!);
        return;
      }
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
