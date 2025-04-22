import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/home/controllers/main_home_controller.dart';

class MainHomeView extends GetView<MainHomeController> {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.pages[controller.currentIndex.value],
        floatingActionButton: SizedBox(
          height: 72,
          width: 72,
          child: FloatingActionButton(
            elevation: 0,
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Text('start'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeTab(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Social",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Shop",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
