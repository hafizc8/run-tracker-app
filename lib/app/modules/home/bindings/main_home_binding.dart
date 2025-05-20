import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/home/controllers/main_home_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_followers_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_following_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';

class MainHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainHomeController>(MainHomeController());
    Get.lazyPut<SocialController>(() => SocialController());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<SocialFollowingController>(() => SocialFollowingController());
    Get.lazyPut<SocialFollowersController>(() => SocialFollowersController());
    Get.lazyPut<EventActionController>(
      () => EventActionController(),
    );
    Get.lazyPut<EventController>(() => EventController());
    Get.lazyPut<SocialClubSearchController>(() => SocialClubSearchController());
  }
}
