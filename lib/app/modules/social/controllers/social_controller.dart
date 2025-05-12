import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';

class SocialController extends GetxController {
  Rx<YourPageChip> selectedChip = YourPageChip.updates.obs;
  ScrollController yourPageScrollController = ScrollController();
  final postController = Get.find<PostController>();

  dynamic selectChip(YourPageChip chip) {
    selectedChip.value = chip;
  }
}
