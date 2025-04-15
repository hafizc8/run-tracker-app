import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/auth/register/controllers/register_create_profile_controller.dart';

class RegisterCreateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterCreateProfileController>(
      () => RegisterCreateProfileController(),
    );
  }
}
