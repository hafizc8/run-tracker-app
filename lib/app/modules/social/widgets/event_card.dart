import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/event_extension.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';

class EventCard extends StatelessWidget {
  EventCard(
      {super.key,
      required this.onTap,
      this.eventModel,
      this.isAction = false,
      this.backgroundColor = Colors.white});

  final EventModel? eventModel;
  final void Function()? onTap;
  final Color backgroundColor;
  final bool isAction;

  final eventController = Get.find<EventController>();
  final eventActionController = Get.find<EventActionController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with button share in right top corner
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  eventModel?.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 64, color: Colors.grey),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Row(
                    children: [
                      // CachedNetworkImage(
                      //   imageUrl: eventModel?.activity ?? '',
                      //   width: 50,
                      //   height: 50,
                      //   fit: BoxFit.cover,
                      //   placeholder: (context, url) =>
                      //       const ShimmerLoadingCircle(size: 50),
                      //   errorWidget: (context, url, error) =>
                      //       const CircleAvatar(
                      //     radius: 32,
                      //     backgroundImage:
                      //         AssetImage('assets/images/empty_profile.png'),
                      //   ),
                      // ),
                      // const SizedBox(width: 8),
                      Text(
                        eventModel?.activity ?? '-',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !isAction,
                  child: Row(
                    children: [
                      Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Visibility(
                        visible: eventModel?.isOwner == 1 &&
                            (eventModel?.datetime ?? DateTime.now())
                                .isDateTimePassed(
                                    eventModel?.startTime ?? TimeOfDay.now()) &&
                            eventModel?.cancelledAt == null,
                        child: PopupMenuButton<String>(
                          onSelected: (value) async {
                            // Handle the selection
                            if (value == 'edit_event') {
                              // Handle Edit Event action
                              eventActionController.gotToEdit(eventModel!,
                                  from: 'list');
                            } else if (value == 'cancel_event') {
                              // Handle Cancel Event action
                              await eventController
                                  .cancelEvent(eventModel?.id ?? '');
                            }
                          },
                          surfaceTintColor:
                              Theme.of(context).colorScheme.onPrimary,
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'edit_event',
                                child: Text(
                                  'Edit Event',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'cancel_event',
                                child: Obx(
                                  () => Visibility(
                                    visible:
                                        eventController.isLoadingAction.value,
                                    replacement: Text(
                                      'Cancel Event',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    child: CircularProgressIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ];
                          },
                          child: Icon(
                            Icons.more_horiz_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // title text
            Text(
              eventModel?.title ?? '-',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FlutterImageStack.widgets(
              showTotalCount: true,
              totalCount: eventModel?.userOnEvents?.length ?? 0,
              itemRadius: 60, // Radius of each images
              itemCount: 4, // Maximum number of images to be shown in stack
              itemBorderWidth: 3, // Border width around the images
              itemBorderColor: Colors.white,
              children: eventModel?.userOnEvents
                      ?.map(
                        (e) => ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: e.user?.imageUrl ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const ShimmerLoadingCircle(size: 50),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  AssetImage('assets/images/empty_profile.png'),
                            ),
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            ),
            const SizedBox(height: 8),
            Text(
              "${eventModel?.userOnEventsCount ?? 0} are Going",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.track_changes_outlined,
                  title: 'QUOTA',
                  subtitle: eventModel?.quota.toString() ?? '-',
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  context,
                  icon: Icons.date_range_outlined,
                  title: 'PERIOD',
                  subtitle:
                      '${DateFormat('d MMM yyyy').format(eventModel!.datetime!)}, ${eventActionController.formatTime(eventModel!.startTime!)}–${eventActionController.formatTime(eventModel!.endTime!)}',
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  context,
                  icon: Icons.map_outlined,
                  title: 'LOCATION',
                  subtitle: eventModel?.address ?? '-',
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  context,
                  icon: Icons.confirmation_num_outlined,
                  title: 'HTM',
                  subtitle:
                      "${(eventModel?.price == null || eventModel?.price == 0) ? 'Free' : eventModel?.price}",
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (isAction) ...[
              GradientElevatedButton(
                onPressed: () {},
                child: SvgPicture.asset(
                  'assets/icons/share.svg',
                  color: Theme.of(context).colorScheme.primary,
                  height: 24,
                  width: 24,
                ),
              ),
            ],

            if (eventModel?.cancelledAt != null) ...[
              GradientElevatedButton(
                onPressed: null,
                child: Text(
                  'Cancelled',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],

            if (eventModel?.cancelledAt == null &&
                (eventModel?.datetime ?? DateTime.now()).isDateTimePassed(
                    eventModel?.startTime ?? TimeOfDay.now())) ...[
              GradientElevatedButton(
                onPressed: eventModel?.isJoined == 0
                    ? () {
                        eventController.accLeaveJoinEvent(eventModel?.id ?? '');
                      }
                    : null,
                child: Obx(
                  () => Visibility(
                    visible: eventController.isLoadingAction.value,
                    replacement:
                        Text((eventModel?.isJoined ?? 0).toEventStatus),
                    child: CustomCircularProgressIndicator(),
                  ),
                ),
              ),
            ]
            // Visibility(
            //   visible: !isAction,
            //   replacement: GradientElevatedButton(
            //     onPressed: () {},
            //     child: SvgPicture.asset(
            //       'assets/icons/share.svg',
            //       color: Theme.of(context).colorScheme.primary,
            //       height: 24,
            //       width: 24,
            //     ),
            //   ),
            //   child: Visibility(
            //     visible: eventModel?.cancelledAt != null,
            //     replacement: Visibility(
            //       visible: (eventModel?.datetime ?? DateTime.now())
            //           .isDateTimePassed(
            //               eventModel?.startTime ?? TimeOfDay.now()),
            //       child: GradientElevatedButton(
            //         onPressed: eventModel?.isJoined == 0
            //             ? () {
            //                 eventController
            //                     .accLeaveJoinEvent(eventModel?.id ?? '');
            //               }
            //             : null,
            //         child: Obx(
            //           () => Visibility(
            //             visible: eventController.isLoadingAction.value,
            //             replacement:
            //                 Text((eventModel?.isJoined ?? 0).toEventStatus),
            //             child: CircularProgressIndicator(
            //               color: Theme.of(context).colorScheme.onPrimary,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     child: GradientElevatedButton(
            //       onPressed: null,
            //       child: Text(
            //         'Cancelled',
            //         style: Theme.of(context).textTheme.labelSmall,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
