import 'package:get/get.dart';

import '../controllers/share_challenge_controller.dart';

class ShareChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareChallengeController>(
      () => ShareChallengeController(),
    );
  }
}