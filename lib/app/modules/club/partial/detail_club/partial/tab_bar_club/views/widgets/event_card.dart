import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/event_extension.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_activity_tab_controller.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EventClubCard extends StatelessWidget {
  EventClubCard(
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
  final eventActivityController = Get.find<ClubActivityTabController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with button share in right top corner
            if (eventModel?.imageUrl != null) ...[
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    eventModel?.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade800,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 64.r,
                          color: Colors.grey,
                        ),
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
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(1.w), // Lebar border
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFA2FF00),
                        Color(0xFF00FF7F),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: eventModel?.activityImageUrl ?? '',
                          width: 13.r,
                          height: 13.r,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              ShimmerLoadingCircle(size: 13.r),
                          errorWidget: (context, url, error) => Icon(
                            size: 13.r,
                            Icons.error,
                          ),
                        ),
                        SizedBox(width: 8.w),
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
                      onTap: () {
                        Get.toNamed(AppRoutes.shareEvent, arguments: eventModel);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/ic_share-2.svg',
                        height: 22.h,
                        width: 27.w,
                      ),
                    ),
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
                            var res = await Get.toNamed(AppRoutes.eventCreate);
                            if (res != null) {
                              var result = await Get.toNamed(
                                  AppRoutes.socialYourPageEventDetail,
                                  arguments: {'eventId': res.id});

                              if (result != null && result is EventModel) {
                                eventActivityController.syncEvent(result);
                              }
                            }
                          } else if (value == 'cancel_event') {
                            // Handle Cancel Event action

                            await eventActivityController
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: SvgPicture.asset(
                            'assets/icons/ic_more_vert.svg',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // title text
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFA2FF00),
                  Color(0xFF00FF7F),
                ],
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                eventModel?.title ?? '-',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      color: Colors.white,
                    ),
              ),
            ),
            SizedBox(height: 16.h),
            ParticipantsAvatars(
              totalUsers: eventModel?.userOnEventsCount ?? 0,
              imageUrls: eventModel?.userOnEvents
                      ?.map((e) => e.user?.imageUrl ?? 'null')
                      .toList() ??
                  [],
              avatarSize: 29,
              overlapOffset: 38,
              maxVisible: 3,
            ),
            SizedBox(height: 8.h),
            Text(
              "${eventModel?.userOnEventsCount ?? 0} / ${eventModel?.quota} are Going",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem(
                  context,
                  icon: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    height: 22.h,
                    width: 27.w,
                  ),
                  title: 'Date & Time',
                  subtitle:
                      '${DateFormat('d MMM yyyy').format(eventModel!.datetime!)}, ${eventModel?.startTime != null ? eventActionController.formatTime(eventModel!.startTime!) : 'Start'}–${eventModel?.endTime != null ? eventActionController.formatTime(eventModel!.endTime!) : 'Finish'}',
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => eventActionController.openGoogleMaps(
                      eventModel?.placeName ?? eventModel?.address ?? '-'),
                  child: _buildInfoItem(
                    context,
                    icon: SvgPicture.asset(
                      'assets/icons/pin_location.svg',
                      height: 22.h,
                      width: 27.w,
                    ),
                    title: 'Location',
                    subtitle:
                        eventModel?.placeName ?? eventModel?.address ?? '-',
                  ),
                ),
                SizedBox(height: 16.h),
                _buildInfoItem(
                  context,
                  icon: SvgPicture.asset(
                    'assets/icons/ic_fee.svg',
                    height: 22.h,
                    width: 27.w,
                  ),
                  title: 'Fee',
                  subtitle:
                      (eventModel?.price == null || eventModel?.price == 0)
                          ? 'Free'
                          : NumberHelper().formatCurrency(eventModel!.price!),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            if (eventModel?.cancelledAt != null) ...[
              SizedBox(
                height: 43.h,
                child: GradientElevatedButton(
                  onPressed: null,
                  child: Text(
                    'Cancelled',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ],

            if (eventModel?.cancelledAt == null &&
                (eventModel?.datetime ?? DateTime.now()).isDateTimePassed(
                    eventModel?.startTime ?? TimeOfDay.now()) &&
                eventModel?.isPublic == 1 &&
                eventModel?.isOwner == 0) ...[
              SizedBox(
                height: 43.h,
                child: GradientElevatedButton(
                  onPressed: eventModel?.isJoined == 0
                      ? () {
                          eventActivityController
                              .confirmAccLeaveJoinEvent(eventModel?.id ?? '');
                        }
                      : null,
                  child: Text(
                    (eventModel?.isJoined ?? 0).toEventStatus,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
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
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12.sp,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 12.sp,
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
