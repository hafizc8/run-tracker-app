import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/auth/register/controllers/register_create_profile_loc_controller.dart';

class RegisterCreateProfileLocBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterCreateProfileLocController>(
      () => RegisterCreateProfileLocController(),
    );
  }
}
