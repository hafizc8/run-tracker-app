import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/club/partial/update_club/controllers/update_club_controller.dart';

class UpdateClubBinding extends Bindings {
  @override
  void dependencies() {
    final clubId = Get.arguments as String;
    Get.put(UpdateClubController(clubId: clubId));
  }
}