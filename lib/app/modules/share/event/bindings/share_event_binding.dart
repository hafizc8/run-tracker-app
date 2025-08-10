import 'package:get/get.dart';

import '../controllers/share_event_controller.dart';

class ShareEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareEventController>(
      () => ShareEventController(),
    );
  }
}