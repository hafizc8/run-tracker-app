import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_detail_controller.dart';

class EventDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventDetailController>(
      () => EventDetailController(),
      fenix: true,
    );
  }
}
