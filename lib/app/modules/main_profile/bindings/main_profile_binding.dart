import 'package:get/get.dart';

import '../controllers/main_profile_controller.dart';

class ProfileMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileMainController>(
      () => ProfileMainController(),
    );
  }
}
