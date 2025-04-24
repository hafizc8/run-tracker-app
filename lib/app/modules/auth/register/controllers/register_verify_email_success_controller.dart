import 'dart:async';

import 'package:get/get.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RegisterVerifyEmailSuccessController extends GetxController {
  var countDown = 5.obs;

  Timer? _timer;
  @override
  void onInit() async {
    startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    countDown.value = 5;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown.value == 0) {
        timer.cancel();
        Get.offAllNamed(AppRoutes.mainHome);
      } else {
        countDown.value--;
      }
    });
  }
}
