import 'package:get/get.dart';

import '../controllers/share_levelup_controller.dart';

class ShareLevelUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareLevelUpController>(
      () => ShareLevelUpController(),
    );
  }
}