import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';

class SocialController extends GetxController {
  Rx<YourPageChip> selectedChip = YourPageChip.updates.obs;
  ScrollController yourPageScrollController = ScrollController();
  final postController = Get.find<PostController>();
  final _debouncer = Debouncer(milliseconds: 500);

  dynamic selectChip(YourPageChip chip) {
    selectedChip.value = chip;
  }

  @override
  void onInit() {
    super.onInit();
    yourPageScrollController.addListener(() {
      if (selectedChip.value == YourPageChip.updates) {
        final position = yourPageScrollController.position;

        bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

        _debouncer.run(() {
          if (isNearBottom && !postController.isLoadingGetAllPost.value && !postController.hasReacheMax.value) {
            postController.getAllPost();
          }
        });
      }
    });
  }
}
