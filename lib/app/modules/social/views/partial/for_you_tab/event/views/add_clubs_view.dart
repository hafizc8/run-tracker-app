import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';

import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';

class AddClubs extends GetView<EventActionController> {
  const AddClubs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Color(0xFF4C4C4C),
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
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Color(0xFFA5A5A5),
                                    ),
                          ),
                        ),
                        child: TextButton(
                          onPressed: controller.unselectAll,
                          child: Text(
                            'Unselect All',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Color(0xFFA5A5A5),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
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
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: GradientOutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                          onPressed: () => Get.back(),
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
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => SizedBox(
                          height: 55,
                          child: GradientElevatedButton(
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
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
