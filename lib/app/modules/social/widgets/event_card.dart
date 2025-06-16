import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/event_extension.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';

class EventCard extends StatelessWidget {
  EventCard(
      {super.key,
      this.onTap,
      this.onCancelEvent,
      this.eventModel,
      this.backgroundColor = Colors.white});

  final EventModel? eventModel;
  final void Function()? onTap;
  final void Function()? onCancelEvent;
  final Color backgroundColor;

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
            if (eventModel?.imageUrl != null) ...[
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    eventModel?.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade800,
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 64, color: Colors.grey),
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(2), // Lebar border
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: eventModel?.activity ?? '',
                          width: 13,
                          height: 13,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ShimmerLoadingCircle(size: 13),
                          errorWidget: (context, url, error) => const Icon(
                            size: 13,
                            Icons.error,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          eventModel?.activity ?? '-',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                        'assets/icons/share.svg',
                        color: Theme.of(context).colorScheme.primary,
                        height: 22,
                        width: 27,
                      ),
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
                            if (onCancelEvent != null) {
                              onCancelEvent!();
                              return;
                            }

                            await eventController
                                .confirmCancelEvent(eventModel!.id!);
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
                              child: Text(
                                'Cancel Event',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ];
                        },
                        child: Icon(
                          Icons.more_vert,
                          size: 27,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // title text
            Text(
              eventModel?.title ?? '-',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),

            ParticipantsAvatars(
              imageUrls: eventModel?.userOnEvents
                      ?.map((e) => e.user?.imageUrl ?? '')
                      .toList() ??
                  [],
              avatarSize: 29,
              overlapOffset: 32,
              maxVisible: 3,
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
                  icon: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    height: 22,
                    width: 27,
                  ),
                  title: 'Date & Time',
                  subtitle:
                      '${DateFormat('d MMM yyyy').format(eventModel!.datetime!)}, ${eventModel?.startTime != null ? eventActionController.formatTime(eventModel!.startTime!) : 'Start'}–${eventModel?.endTime != null ? eventActionController.formatTime(eventModel!.endTime!) : 'Finish'}',
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  context,
                  icon: SvgPicture.asset(
                    'assets/icons/pin_location.svg',
                    height: 22,
                    width: 27,
                  ),
                  title: 'Location',
                  subtitle: eventModel?.address ?? '-',
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  context,
                  icon: SvgPicture.asset(
                    'assets/icons/dollar.svg',
                    height: 22,
                    width: 27,
                  ),
                  title: 'Fee',
                  subtitle:
                      "${(eventModel?.price == null || eventModel?.price == 0) ? 'Free' : eventModel?.price}",
                ),
              ],
            ),
            const SizedBox(height: 15),

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
                    eventModel?.startTime ?? TimeOfDay.now()) &&
                eventModel?.isPublic == 1 &&
                eventModel?.isOwner == 0) ...[
              GradientElevatedButton(
                onPressed: eventModel?.isJoined == 0
                    ? () {
                        eventController
                            .confirmAccLeaveJoinEvent(eventModel?.id ?? '');
                      }
                    : null,
                child: Text(
                  (eventModel?.isJoined ?? 0).toEventStatus,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required SvgPicture icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 12,
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
