import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_followers_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_following_controller.dart';

class SocialController extends GetxController with GetSingleTickerProviderStateMixin {
  Rx<YourPageChip> selectedChip = YourPageChip.updates.obs;
  ScrollController yourPageScrollController = ScrollController();
  final postController = Get.find<PostController>();
  final followingController = Get.find<SocialFollowingController>();
  final followersController = Get.find<SocialFollowersController>();
  final clubSearchController = Get.find<SocialClubSearchController>();
  
  late var tabBarController;

  final RxInt selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    tabBarController = TabController(length: 2, vsync: this);
    tabBarController.addListener(() {
      changeTabIndex(tabBarController.index);
    });
  }

  dynamic selectChip(YourPageChip chip) {
    selectedChip.value = chip;
    if (selectedChip.value == YourPageChip.following) {
      followingController.load();
    } else if (selectedChip.value == YourPageChip.followers) {
      followersController.load();
    } else if (selectedChip.value == YourPageChip.clubs) {
      clubSearchController.load();
    }
  }
}
