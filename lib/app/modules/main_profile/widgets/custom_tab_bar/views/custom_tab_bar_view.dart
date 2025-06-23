import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/card_activity.dart';
import 'package:zest_mobile/app/core/shared/widgets/card_challenge.dart';
import 'package:zest_mobile/app/modules/main_profile/controllers/main_profile_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/card_event/card_event_profile.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/custom_tab_bar/controllers/custom_tab_bar_controller.dart';

import 'package:zest_mobile/app/routes/app_routes.dart';

class CustomTabBar extends GetView<TabBarController> {
  CustomTabBar({super.key});

  final List<String> tabs = ['Overview', 'Challenges', 'Events'];

  final ProfileMainController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(tabs.length, (index) {
            return Obx(() {
              final isSelected = controller.selectedIndex.value == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTabIndex(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF393939),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              );
            });
          }),
        ),
        const SizedBox(height: 16),
        Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardActivity(),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.activity),
                      child: Text(
                        'See All',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ),
                ],
              );
            case 1:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              );
            case 2:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          onTap: () async {
                            if (profileController.events[index].cancelledAt !=
                                null) {
                              return;
                            }
                            var result = await Get.toNamed(
                                AppRoutes.socialYourPageEventDetail,
                                arguments: {
                                  'eventId': profileController.events[index].id
                                });
                            if (result != null && result is EventModel) {
                              int index = profileController.events.indexWhere(
                                  (element) => element.id == result.id);
                              profileController.events[index] = result.copyWith(
                                userOnEventsCount: result.userOnEvents?.length,
                              );
                            }
                          },
                          onCancelEvent: () => profileController
                              .confirmCancelEvent(event.id ?? ''),
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
              );
            default:
              return const SizedBox();
          }
        }),
      ],
    );
  }
}
