import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/activity/record_activity/controllers/record_activity_controller.dart';

class RecordActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordActivityController>(
      () => RecordActivityController(),
    );
  }
}
