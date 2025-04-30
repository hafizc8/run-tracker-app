import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/challenge/controllers/challenge_controller.dart';

class ChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallengeController>(
      () => ChallengeController(),
      fenix: true,
    );
  }
}
