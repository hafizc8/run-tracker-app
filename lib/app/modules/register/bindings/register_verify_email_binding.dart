import 'package:get/get.dart';

import '../controllers/register_verify_email_controller.dart';

class RegisterVerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterVerifyEmailController>(
      () => RegisterVerifyEmailController(),
    );
  }
}
