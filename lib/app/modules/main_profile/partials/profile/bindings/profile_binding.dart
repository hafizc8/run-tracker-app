import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
