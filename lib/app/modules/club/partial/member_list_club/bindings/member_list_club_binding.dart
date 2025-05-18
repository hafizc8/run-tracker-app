import 'package:get/get.dart';
import '../controllers/member_list_club_controller.dart';

class MemberListClubBinding extends Bindings {
  @override
  void dependencies() {
    final clubId = Get.arguments as String;
    Get.put(MemberListClubController(clubId: clubId));
  }
}