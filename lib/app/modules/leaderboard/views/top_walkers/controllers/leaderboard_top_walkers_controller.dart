import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/leaderboard_top_walkers_page_enum.dart';

class LeaderboardTopWalkersController extends GetxController {
  Rx<LeaderboardTopWalkersPageEnum> selectedChip = LeaderboardTopWalkersPageEnum.global.obs;

  RxBool isFriendsOnly = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  dynamic selectChip(LeaderboardTopWalkersPageEnum chip) {
    selectedChip.value = chip;
    if (selectedChip.value == LeaderboardTopWalkersPageEnum.global) {
      // load data global
    } else if (selectedChip.value == LeaderboardTopWalkersPageEnum.country) {
      // load data country
    } else if (selectedChip.value == LeaderboardTopWalkersPageEnum.province) {
      // load data province
    }
  }
}