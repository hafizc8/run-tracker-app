import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/challenge/controllers/create_challenge_controller.dart';

class ChallengeCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallangeCreateController>(
      () => ChallangeCreateController(),
    );
  }
}
