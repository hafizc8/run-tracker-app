import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/login_form.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class LoginController extends GetxController {
  Rx<LoginFormModel> form = LoginFormModel().obs;
  var isVisiblePassword = true.obs;
  var isLoading = false.obs;
  var isLoadingGoogle = false.obs;
  final _authService = sl<AuthService>();

  Future<void> login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoading.value = true;
    form.value = form.value.clearErrors();
    try {
      bool resp = await _authService.login(
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
    form.value = form.value.clearErrors();
    try {
      bool resp = await _authService.loginWithGoogle();
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
      isLoadingGoogle.value = false;
    }
  }
}
