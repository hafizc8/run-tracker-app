import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_all_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_club_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_event_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_friend_controller.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InboxController>(() => InboxController());
    Get.lazyPut<InboxAllController>(() => InboxAllController());
    Get.lazyPut<InboxFriendController>(() => InboxFriendController());
    Get.lazyPut<InboxClubController>(() => InboxClubController());
    Get.lazyPut<InboxEventController>(() => InboxEventController());
  }
}
