import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';

class AddClubs extends GetView<EventActionController> {
  const AddClubs({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 402,
        child: RefreshIndicator(
          onRefresh: () => controller.getClubs(),
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Clubs',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.tempSelectedIds.length ==
                              controller.eventClubs.length,
                          replacement: TextButton(
                            onPressed: () => controller.selectAll(),
                            child: Text(
                              'Select All',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: controller.unselectAll,
                            child: Text(
                              'Unselect All',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoadingClub.value) {
                        return ListView(
                          shrinkWrap: true,
                          children: List.generate(
                            5,
                            (index) => Shimmer.fromColors(
                              highlightColor: Colors.grey.shade100,
                              baseColor: Colors.grey.shade300,
                              child: Container(
                                width: double.infinity,
                                height: 24,
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        );
                      }
                      return ListView(
                        shrinkWrap: true,
                        children: controller.eventClubs.map((club) {
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: controller.tempSelectedIds.contains(club),
                            title: Text(
                              club.name ?? '-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (_) => controller.toggleClub(club),
                          );
                        }).toList(),
                      );

                      // return Text('semua');
                    }),
                  ),

                  const SizedBox(height: 70),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: // Buttons
                    Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            side: const BorderSide(color: Color(0xFF007BFF)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.tempSelectedIds.isNotEmpty
                                ? () {
                                    controller.commitSelection();
                                  }
                                : null,
                            child: Text('CHOOSE',
                                style: Theme.of(context).textTheme.labelMedium),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
