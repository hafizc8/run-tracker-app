import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/choose_location_event/controllers/choose_location_event_controller.dart';

class ChooseLocationEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseLocationEventController>(
      () => ChooseLocationEventController(),
      fenix: true,
    );
  }
}
