import 'package:get/get.dart';

import '../controllers/share_profile_controller.dart';

class ShareProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareProfileController>(
      () => ShareProfileController(),
    );
  }
}