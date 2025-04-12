import 'package:get/get.dart';

import '../controllers/register_verify_email_controller.dart';

class RegisterVerifyEmailSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterVerifyEmailController>(
      () => RegisterVerifyEmailController(),
    );
  }
}
