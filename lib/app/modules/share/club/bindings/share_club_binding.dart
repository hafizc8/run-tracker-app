import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';

import '../controllers/share_club_controller.dart';

class ShareClubBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments is ClubModel) {
      final clubModel = Get.arguments as ClubModel;
      Get.put(ShareClubController(clubModel: clubModel));
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