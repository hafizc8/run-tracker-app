import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/activity/controllers/activity_controller.dart';

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(
      () => ActivityController(),
      fenix: true,
    );
  }
}
