import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/card_activity.dart';
import 'package:zest_mobile/app/core/shared/widgets/card_challenge.dart';
import 'package:zest_mobile/app/modules/main_profile/controllers/main_profile_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/custom_tab_bar/controllers/custom_tab_bar_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class CustomTabBar extends GetView<TabBarController> {
  CustomTabBar({super.key});

  final List<String> tabs = ['Overview', 'Challenge', 'Events'];

  final ProfileMainController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor, // Warna border
                width: 1.0, // Ketebalan border
              ),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: List.generate(tabs.length, (index) {
              return Obx(() {
                final isSelected = controller.selectedIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.changeTabIndex(index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                );
              });
            }),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Activity',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const CardActivity(),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.activity),
                        child: Text(
                          'See All',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case 1:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == profileController.challenges.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final challenge = profileController.challenges[index];
                          return CardChallenge(
                            challengeModel: challenge,
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: profileController.challenges.length +
                            (profileController.hasReacheMaxChallenge.value
                                ? 0
                                : 1),
                      );
                    })
                  ],
                ),
              );
            case 2:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Placeholder(
                                fallbackHeight: 40,
                                fallbackWidth: 80,
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Placeholder(
                                fallbackHeight: 40,
                                fallbackWidth: 80,
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Placeholder(
                                fallbackHeight: 40,
                                fallbackWidth: 80,
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Placeholder(
                                fallbackHeight: 40,
                                fallbackWidth: 80,
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'item',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Created Events',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index == profileController.events.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final event = profileController.events[index];
                          return EventCard(
                            onTap: null,
                            eventModel: event,
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: profileController.events.length +
                            (profileController.hasReacheMaxEvent.value ? 0 : 1),
                      );
                    })
                  ],
                ),
              );
            default:
              return const SizedBox();
          }
        }),
      ],
    );
  }
}
