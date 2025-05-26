import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/see_all_participant_controller.dart';

class EventDetailSeeAllParticipantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeeAllParticipantController>(
      () => SeeAllParticipantController(),
      fenix: true,
    );
  }
}
