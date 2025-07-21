import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/challenge/controllers/challenge_invite_friend_controller.dart';

class ChallengeInviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallengeInviteController>(
      () => ChallengeInviteController(),
    );
  }
}
