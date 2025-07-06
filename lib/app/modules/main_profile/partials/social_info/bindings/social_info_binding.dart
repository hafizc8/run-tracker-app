import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_clubs.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_followers.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_following.dart';

class SocialInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SocialInfoController(),
    );
    Get.lazyPut(
      () => SocialInfoFollowingController(),
    );
    Get.lazyPut(
      () => SocialInfoFollowersController(),
    );
    Get.lazyPut(
      () => SocialInfoClubsController(),
    );
  }
}
