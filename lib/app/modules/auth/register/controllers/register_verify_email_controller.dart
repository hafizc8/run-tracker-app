import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';

class RegisterVerifyEmailController extends GetxController {
  final AuthService _authService = sl<AuthService>();
  UserModel? get user => _authService.user;

  var resendCooldown = 30.obs;
  var canResend = false.obs;

  var isLoading = false.obs;
  var isLoading1 = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    resetTimer();
    startTimer();
    debugPrint("Controller onInit: $hashCode");
    super.onInit();
  }

  @override
  void onClose() {
    resetTimer();
    super.onClose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
        debugPrint(resendCooldown.value.toString());
      }
      if (resendCooldown.value == 0) {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    resendCooldown.value = 30;
    canResend.value = false;
    _timer?.cancel();
  }

  Future<void> sendEmailVerify() async {
    isLoading.value = true;

    try {
      bool resp = await _authService.sendEmailVerify();
      if (resp) {
        Get.snackbar(
          'Success',
          'Email verification sent',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      resetTimer();
      startTimer();
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
