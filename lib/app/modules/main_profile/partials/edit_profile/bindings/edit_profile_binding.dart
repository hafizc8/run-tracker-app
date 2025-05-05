import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/edit_profile/controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(),
      fenix: true,
    );
  }
}
