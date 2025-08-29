import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_activity_tab_controller.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_leaderboard_tab_controller.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/tab_bar_club_controller.dart';

import '../controllers/detail_club_controller.dart';

class DetailClubBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailClubController());

    Get.lazyPut<TabBarClubController>(
      () => TabBarClubController(),
      fenix: true,
    );
    Get.lazyPut<ClubActivityTabController>(
      () => ClubActivityTabController(),
      fenix: true,
    );
    Get.lazyPut<ClubLeaderboardTabController>(
      () => ClubLeaderboardTabController(),
      fenix: true,
    );
  }
}
