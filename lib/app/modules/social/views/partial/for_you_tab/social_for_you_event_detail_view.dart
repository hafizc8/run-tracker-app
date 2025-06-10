import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_event.dart';

import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_detail_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_detail_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialForYouEventDetailView extends GetView<EventDetailController> {
  SocialForYouEventDetailView({super.key});

  final eventController = Get.find<EventController>();
  final eventActionController = Get.find<EventActionController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Visibility(
            visible: controller.isLoading.value,
            replacement: EventDetailCard(
              event: controller.event.value,
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: EventShimmer(),
            ),
          ),
        ),
        bottomNavigationBar:
            (controller.event.value?.datetime ?? DateTime.now())
                    .isDateTimePassed(
                        controller.event.value?.startTime ?? TimeOfDay.now())
                ? _buildBottomBar(context)
                : const SizedBox(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onBackground,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Event Details',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade700,
            child: const SizedBox(
              height: 40,
              width: 200,
            ),
          );
        }
        if (controller.event.value?.cancelledAt != null) {
          return SizedBox(
            height: 55,
            child: GradientOutlinedButton(
              onPressed: null,
              child: Text(
                'Cancelled',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          );
        }

        if (controller.event.value?.isJoined == 1) {
          return Obx(
            () => Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: controller.event.value?.isOwner == 0,
                    replacement: SizedBox(
                      height: 55,
                      child: GradientOutlinedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                        onPressed: () {
                          eventController.cancelEvent(
                            controller.event.value?.id ?? '',
                          );
                        },
                        child: Visibility(
                          visible: !eventController.isLoadingAction.value,
                          replacement: CustomCircularProgressIndicator(),
                          child: Text(
                            'Cancel Event',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: 55,
                      child: GradientOutlinedButton(
                        onPressed: () {
                          controller.accLeaveJoinEvent(
                            controller.event.value?.id ?? '',
                            leave: '1',
                          );
                        },
                        child: Visibility(
                          visible: !controller.isLoadingAction.value,
                          replacement: CustomCircularProgressIndicator(),
                          child: Text(
                            'Leave Event',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: GradientElevatedButton(
                      onPressed: () async {
                        var res = await Get.toNamed(
                            AppRoutes.socialYourPageEventDetailInviteFriend,
                            arguments: {'eventId': controller.event.value?.id});
                        if (res != null && res) {
                          controller.init();
                        }
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/add_friends.svg',
                            height: 22,
                            width: 27,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Invite a Friend',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.event.value?.isJoined == 0 &&
            controller.event.value?.isPublic == 1) {
          return Obx(
            () => SizedBox(
              height: 55,
              child: GradientElevatedButton(
                onPressed: () {
                  controller
                      .accLeaveJoinEvent(controller.event.value?.id ?? '');
                },
                child: Visibility(
                  visible: !controller.isLoadingAction.value,
                  replacement: CustomCircularProgressIndicator(),
                  child: Text(
                    'Join!',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      }),
    );
  }
}
