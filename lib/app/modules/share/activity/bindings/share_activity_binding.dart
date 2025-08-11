import 'package:get/get.dart';

import '../controllers/share_activity_controller.dart';

class ShareActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareActivityController>(
      () => ShareActivityController(),
    );
  }
}