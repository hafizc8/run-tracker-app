import 'package:get/get.dart';
import '../controllers/invite_to_club_controller.dart';

class InviteToClubBinding extends Bindings {
  @override
  void dependencies() {
    final clubId = Get.arguments as String;
    Get.put(InviteToClubController(clubId: clubId));
  }
}