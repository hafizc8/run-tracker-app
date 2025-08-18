import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';

import '../controllers/share_event_controller.dart';

class ShareEventBinding extends Bindings {
  @override
  void dependencies() {
    final eventModel = Get.arguments as EventModel;
    Get.put(ShareEventController(eventModel: eventModel));
  }
}