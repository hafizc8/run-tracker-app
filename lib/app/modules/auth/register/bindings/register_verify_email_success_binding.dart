import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/auth/register/controllers/register_verify_email_success_controller.dart';

class RegisterVerifyEmailSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterVerifyEmailSuccessController>(
      () => RegisterVerifyEmailSuccessController(),
    );
  }
}
