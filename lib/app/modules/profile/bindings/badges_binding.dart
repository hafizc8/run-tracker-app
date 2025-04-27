import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/profile/controllers/badges_controller.dart';

class BadgesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BadgesController>(
      () => BadgesController(),
      fenix: true,
    );
  }
}
