import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarClubController extends GetxController with GetSingleTickerProviderStateMixin {
  final RxInt selectedIndex = 0.obs;

  late var tabBarController;

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
}
