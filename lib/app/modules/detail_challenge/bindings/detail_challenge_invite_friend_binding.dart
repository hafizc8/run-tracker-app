import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/detail_challenge/controllers/detail_challenge_invite_friend_controller.dart';

class DetailChallengeInviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailChallengeInviteController>(
      () => DetailChallengeInviteController(),
    );
  }
}
