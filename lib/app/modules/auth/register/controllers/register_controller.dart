import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/register_form.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RegisterController extends GetxController {
  Rx<RegisterFormModel> form = RegisterFormModel().obs;
  var isLoading = false.obs;
  var isLoadingGoogle = false.obs;
  final _authService = sl<AuthService>();

  var isVisiblePassword = true.obs;
  var isVisiblePasswordConfirmation = true.obs;

  Future<void> register(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    form.value = form.value.clearErrors();
    try {
      bool resp = await _authService.register(
        form.value,
      );
      if (resp) Get.offAllNamed(AppRoutes.mainHome);
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

  Future<void> loginWithGoogle() async {
    isLoadingGoogle.value = true;
    try {
      final resp = await _authService.loginWithGoogle();
      if (resp) Get.offAllNamed(AppRoutes.mainHome);
    } catch (e) {
      // Map exception messages into friendly text
      String message;
      if (e.toString().contains("cancelled_by_user")) {
        message = "Login cancelled by user.";
      } else if (e.toString().contains("firebase_")) {
        message = "Firebase Auth error: ${e.toString().split('_').last}";
      } else if (e.toString().contains("platform_")) {
        message = "Google sign-in error: ${e.toString().split('_').last}";
      } else {
        message = "Unexpected error: $e";
      }

      Get.snackbar('Auth Error', message);
    } finally {
      isLoadingGoogle.value = false;
    }
  }
}
