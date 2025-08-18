import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';

import '../controllers/share_challenge_progress_individual_controller.dart';

class ShareChallengeProgressIndividualBinding extends Bindings {
  @override
  void dependencies() {
    final challengeModel = Get.arguments as ChallengeDetailModel;
    Get.put(ShareChallengeProgressIndividualController(challengeModel: challengeModel));
  }
}