import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_event.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_detail_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialForYouEventDetailView extends GetView<SocialController> {
  SocialForYouEventDetailView({super.key});

  final eventController = Get.find<EventController>();
  final eventActionController = Get.find<EventActionController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Obx(
          () => Visibility(
            visible: eventController.isLoadingDetail.value,
            replacement: EventDetailCard(
              event: eventController.event.value,
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: EventShimmer(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.primary,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Event Details',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
      actions: [
        Obx(() {
          return eventController.event.value?.isOwner == 1
              ? PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle the selection
                    if (value == 'edit') {
                      // Handle Edit Event action
                      eventActionController.gotToEdit(
                          eventController.event.value!,
                          from: 'detail');
                    } else if (value == 'delete') {
                      // Handle Delete Event action
                    }
                  },
                  icon: Icon(
                    Icons.more_horiz,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(
                          'Edit Event',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(
                          'Delete Event',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ];
                  },
                )
              : const SizedBox();
        })
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Obx(
        () => Visibility(
          visible: !eventController.isLoadingDetail.value,
          replacement: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: const SizedBox(
              height: 40,
              width: 200,
            ),
          ),
          child: Visibility(
            visible: eventController.event.value?.cancelledAt == null,
            replacement: ElevatedButton(
              onPressed: null,
              child: Text(
                'Cancelled',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            child: Visibility(
              visible: eventController.event.value?.isJoined == 1,
              replacement: ElevatedButtonTheme(
                data: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    eventController.accLeaveJoinEvent(
                        eventController.event.value?.id ?? '');
                  },
                  child: Visibility(
                    visible: !eventController.isLoadingAction.value,
                    replacement: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(
                      eventController.event.value?.isJoined == 0
                          ? 'Join'
                          : 'Joined',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButtonTheme(
                      data: OutlinedButtonThemeData(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          minimumSize: const Size.fromHeight(40),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      child: Visibility(
                        visible: eventController.event.value?.isOwner == 0,
                        replacement: OutlinedButton(
                          onPressed: () {
                            eventController.cancelEvent(
                              eventController.event.value?.id ?? '',
                            );
                          },
                          child: Visibility(
                            visible: !eventController.isLoadingAction.value,
                            replacement: const CircularProgressIndicator(),
                            child: Text(
                              'Cancel Event',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            eventController.accLeaveJoinEvent(
                                eventController.event.value?.id ?? '',
                                leave: '1');
                          },
                          child: Visibility(
                            visible: !eventController.isLoadingAction.value,
                            replacement: const CircularProgressIndicator(),
                            child: Text(
                              'Leave Event',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButtonTheme(
                      data: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          minimumSize: const Size.fromHeight(40),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                              AppRoutes.socialYourPageEventDetailInviteFriend);
                        },
                        child: Text(
                          'Invite a Friend',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
