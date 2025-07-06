import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_info_page_enum.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_clubs.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_followers.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_following.dart';

class SocialInfoController extends GetxController {
  var name = ''.obs;
  var id = ''.obs;
  Rx<YourPageChip?> selectedChip = Rx(null);
  final followingController = Get.find<SocialInfoFollowingController>();
  final followersController = Get.find<SocialInfoFollowersController>();
  final clubsController = Get.find<SocialInfoClubsController>();

  @override
  void onInit() {
    if (Get.arguments == null) return;
    if (Get.arguments['name'] != null) {
      name.value = Get.arguments['name'];
    }

    switch (Get.arguments['page']) {
      case 0:
        selectedChip.value = YourPageChip.following;
        followingController.load(refresh: true);
        break;
      case 1:
        selectedChip.value = YourPageChip.followers;
        followersController.load(refresh: true);
        break;
      case 2:
        selectedChip.value = YourPageChip.clubs;
        clubsController.load(refresh: true);
        break;
      default:
    }
    super.onInit();
  }

  dynamic selectChip(YourPageChip chip) {
    selectedChip.value = chip;
    if (selectedChip.value == YourPageChip.following) {
      followingController.load(refresh: true);
    } else if (selectedChip.value == YourPageChip.followers) {
      followersController.load(refresh: true);
    } else if (selectedChip.value == YourPageChip.clubs) {
      clubsController.load(refresh: true);
    }
  }
}
