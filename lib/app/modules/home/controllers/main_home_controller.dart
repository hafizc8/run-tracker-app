import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/home/views/home_view.dart';
import 'package:zest_mobile/app/modules/home/views/shop_view.dart';
import 'package:zest_mobile/app/modules/main_profile/views/main_profile_view.dart';
import 'package:zest_mobile/app/modules/social/views/social_view.dart';

class MainHomeController extends GetxController {
  var currentIndex = 0.obs;
  List<Widget> get pages => const [
        HomeView(),
        SocialView(),
        ShopView(),
        MainProfileView(),
      ];
  void changeTab(int index) {
    currentIndex.value = index;
    print('tab has changed to $index');
  }
}
