import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';

import '../controllers/share_challenge_controller.dart';

class ShareChallengeBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments is ChallengeModel) {
      final challengeModel = Get.arguments as ChallengeModel;
      Get.put(ShareChallengeController(challengeModel: challengeModel));
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