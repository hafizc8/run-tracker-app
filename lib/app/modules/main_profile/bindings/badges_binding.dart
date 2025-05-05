import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/controllers/badges_controller.dart';

class BadgesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BadgesController>(
      () => BadgesController(),
      fenix: true,
    );
  }
}
