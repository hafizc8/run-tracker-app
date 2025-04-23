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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: SizedBox(
            height: 72,
            width: 72,
            child: FloatingActionButton(
              elevation: 0,
              shape: const CircleBorder(),
              onPressed: () {},
              child: const Text('start'),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: 96,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => controller.changeTab(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: controller.currentIndex.value == 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    Text(
                      'Home',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: controller.currentIndex.value == 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.changeTab(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people,
                      color: controller.currentIndex.value == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    Text(
                      'Social',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: controller.currentIndex.value == 1
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => controller.changeTab(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: controller.currentIndex.value == 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    Text(
                      'Shop',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: controller.currentIndex.value == 2
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.changeTab(3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: controller.currentIndex.value == 3
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: controller.currentIndex.value == 3
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
