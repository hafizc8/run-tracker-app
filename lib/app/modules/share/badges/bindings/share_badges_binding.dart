import 'package:get/get.dart';
import '../controllers/share_badges_controller.dart';

class ShareBadgesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareBadgesController>(
      () => ShareBadgesController(),
    );
  }
}