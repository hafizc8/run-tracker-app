import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/record_activity_model.dart';
import 'package:zest_mobile/app/modules/activity/edit_activity/controllers/edit_activity_controller.dart';

class EditActivityBinding extends Bindings {
  @override

  void dependencies() {
    final recordActivityData = Get.arguments as RecordActivityModel;
    Get.put(EditActivityController(recordActivityData: recordActivityData));
  }
}