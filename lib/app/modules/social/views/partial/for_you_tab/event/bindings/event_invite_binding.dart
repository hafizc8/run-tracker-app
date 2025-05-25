import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_invite_controller.dart';

class EventInviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventInviteController>(
      () => EventInviteController(),
      fenix: true,
    );
  }
}
