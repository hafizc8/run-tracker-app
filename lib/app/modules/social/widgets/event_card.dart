import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/event_extension.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with button share in right top corner
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.grey.shade300,
                      child: CachedNetworkImage(
                        imageUrl: eventModel?.imageUrl ?? '',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: const SizedBox.shrink(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Image Placeholder',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isAction,
                  child: Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Icon(
                            Icons.share_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Visibility(
                          visible: eventModel?.isOwner == 1 &&
                              (eventModel?.datetime ?? DateTime.now())
                                  .isFuture &&
                              eventModel?.cancelledAt == null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
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
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'cancel_event',
                                    child: Obx(
                                      () => Visibility(
                                        visible: eventController
                                            .isLoadingAction.value,
                                        replacement: Text(
                                          'Cancel Event',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // title text
            Text(
              eventModel?.title ?? '-',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: Icons.track_changes_outlined,
                        title: 'QUOTA',
                        subtitle: eventModel?.quota.toString() ?? '-',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: Icons.date_range_outlined,
                        title: 'PERIOD',
                        subtitle: (eventModel?.datetime ?? DateTime.now())
                            .toddMMMyyyy(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: Icons.map_outlined,
                        title: 'LOCATION',
                        subtitle: eventModel?.address ?? '-',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: Icons.confirmation_num_outlined,
                        title: 'HTM',
                        subtitle:
                            "${(eventModel?.price == null || eventModel?.price == 0) ? 'Free' : eventModel?.price}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Visibility(
              visible: !isAction,
              replacement: ElevatedButton(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              child: Visibility(
                visible: eventModel?.cancelledAt != null,
                replacement: Visibility(
                  visible: (eventModel?.datetime ?? DateTime.now()).isFuture,
                  child: ElevatedButton(
                    onPressed: eventModel?.isJoined == 0
                        ? () {
                            eventController
                                .accLeaveJoinEvent(eventModel?.id ?? '');
                          }
                        : null,
                    child: Obx(
                      () => Visibility(
                        visible: eventController.isLoadingAction.value,
                        replacement:
                            Text((eventModel?.isJoined ?? 0).toEventStatus),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'Cancelled',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
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
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
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
