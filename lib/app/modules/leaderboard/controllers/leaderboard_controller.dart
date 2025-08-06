// leaderboard_controller

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController with GetSingleTickerProviderStateMixin {
  var tabs = ['Top Walkers', 'Challenge'].obs;

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}