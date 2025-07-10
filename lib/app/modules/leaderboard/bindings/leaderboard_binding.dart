// leaderboard_binding.dart

import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/leaderboard/controllers/leaderboard_controller.dart';

class LeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaderboardController());
  }
}