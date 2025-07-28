import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/challenge/controllers/edit_challenge_controller.dart';

class ChallengeEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChallangeEditController>(
      () => ChallangeEditController(),
    );
  }
}
