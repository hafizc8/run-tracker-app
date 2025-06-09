import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/activity/start_activity/controllers/start_activity_controller.dart';

class StartActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartActivityController>(
      () => StartActivityController(),
    );
  }
}
