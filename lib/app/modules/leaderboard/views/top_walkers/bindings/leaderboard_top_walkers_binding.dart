import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/controllers/leaderboard_top_walkers_controller.dart';

class LeaderboardTopWalkersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaderboardTopWalkersController());
  }
}