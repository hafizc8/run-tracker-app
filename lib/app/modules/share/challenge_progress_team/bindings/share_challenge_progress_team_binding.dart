import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_team_model.dart';

import '../controllers/share_challenge_progress_team_controller.dart';

class ShareChallengeProgressTeamBinding extends Bindings {
  @override
  void dependencies() {
    final challengeModel = Get.arguments['detailChallenge'] as ChallengeDetailModel;
    final team = Get.arguments['team'] as Map<String, List<ChallengeTeamsModel>>;
    Get.put(ShareChallengeProgressTeamController(challengeModel: challengeModel, team: team));
  }
}