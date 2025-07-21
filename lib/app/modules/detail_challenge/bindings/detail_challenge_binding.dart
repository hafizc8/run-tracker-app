import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/detail_challenge/controllers/detail_challenge_controller.dart';

class DetailChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DetailChallangeController>(
      DetailChallangeController(),
    );
  }
}
