import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/inbox_page_enum.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_all_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_club_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_event_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_friend_controller.dart';

class InboxController extends GetxController {
  Rx<InboxChip> selectedChip = InboxChip.all.obs;
  final _all = Get.find<InboxAllController>();
  final _friend = Get.find<InboxFriendController>();
  final _club = Get.find<InboxClubController>();
  final _event = Get.find<InboxEventController>();

  dynamic selectChip(InboxChip chip) {
    selectedChip.value = chip;
    if (selectedChip.value == InboxChip.all) {
      _all.refreshAll();
    } else if (selectedChip.value == InboxChip.friends) {
      _friend.refreshFriend();
    } else if (selectedChip.value == InboxChip.clubs) {
      _club.refreshClubs();
    } else if (selectedChip.value == InboxChip.event) {
      _event.refreshEvents();
    }
  }
}
