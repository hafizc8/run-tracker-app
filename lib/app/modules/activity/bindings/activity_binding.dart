import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/activity/controllers/activity_controller.dart';

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(
      () => ActivityController(),
      fenix: true,
    );
  }
}
