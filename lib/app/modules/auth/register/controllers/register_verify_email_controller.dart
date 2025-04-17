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

  final resendCooldown = 30.obs;
  final canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    sendEmailVerify();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    canResend.value = false;
    resendCooldown.value = 30;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        resendCooldown.value--;
      }
    });
  }

  Future<void> sendEmailVerify() async {
    startTimer();
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
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
