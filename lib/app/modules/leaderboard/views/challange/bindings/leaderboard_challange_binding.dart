import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/challange/controllers/leaderboard_challange_controller.dart';

class LeaderboardChallangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaderboardChallangeController());
  }
}