import 'package:get/get.dart';
import '../controllers/invite_to_club_controller.dart';

class InviteToClubBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments is String) {
      final clubId = Get.arguments as String;
      Get.put(InviteToClubController(clubId: clubId));
    } else {
      Future.delayed(Duration.zero, () {
        Get.snackbar("Error", "Could not load data");
        if (Get.previousRoute.isNotEmpty) {
          Get.back(closeOverlays: true);
        }
      });
    }
  }
}