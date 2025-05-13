import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_followers_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_following_controller.dart';

class SocialController extends GetxController {
  Rx<YourPageChip> selectedChip = YourPageChip.updates.obs;
  ScrollController yourPageScrollController = ScrollController();
  final postController = Get.find<PostController>();
  final followingController = Get.find<SocialFollowingController>();
  final followersController = Get.find<SocialFollowersController>();

  dynamic selectChip(YourPageChip chip) {
    selectedChip.value = chip;
    if (selectedChip.value == YourPageChip.following) {
      followingController.load();
    } else if (selectedChip.value == YourPageChip.followers) {
      followersController.load();
    }
  }
}
