import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_detail_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EventDetailCard extends GetView<EventDetailController> {
  EventDetailCard({super.key, required this.event});
  final EventModel? event;
  final eventActionController = Get.find<EventActionController>();
  final eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (event?.imageUrl != null) ...[
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  color: Colors.grey.shade300,
                  child: CachedNetworkImage(
                    imageUrl: event?.imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade700,
                      child: const SizedBox.shrink(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 64.r, color: Colors.grey),
                          SizedBox(height: 8.h),
                          const Text('Image Placeholder',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w), // Lebar border
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: event?.activityImageUrl ?? '',
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
                        event?.activity ?? '-',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_share-2.svg',
                    height: 22.h,
                    width: 27.w,
                  ),
                  SizedBox(width: 16.w),
                  Visibility(
                    visible: event?.isOwner == 1 &&
                        (event?.datetime ?? DateTime.now()).isDateTimePassed(
                            event?.startTime ?? TimeOfDay.now()) &&
                        event?.cancelledAt == null,
                    child: PopupMenuButton<String>(
                      onSelected: (value) async {
                        // Handle the selection
                        if (value == 'edit_event') {
                          // Handle Edit Event action
                          eventActionController.gotToEdit(event!, from: 'list');
                          var res = await Get.toNamed(AppRoutes.eventCreate);
                          if (res != null) {
                            controller.detailEvent();
                          }
                        } else if (value == 'cancel_event') {
                          // Handle Cancel Event action
                          await eventController.confirmCancelEvent(event!.id!);
                        }
                      },
                      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
                                visible: eventController.isLoadingAction.value,
                                replacement: Text(
                                  'Cancel Event',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      child: SvgPicture.asset(
                        'assets/icons/ic_more_vert.svg',
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
              event?.title ?? '-',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    color: Colors.white,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organized By',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA5A5A5),
                    ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: event?.user?.imageUrl ?? '',
                      width: 29.r,
                      height: 29.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: const SizedBox.shrink(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 24.r,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event?.user?.name ?? '-',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15.h),
          // description
          Text(
            event?.description ?? '-',
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 15.h),
          Text(
            "${event?.userOnEventsCount ?? 0} / ${event?.quota} are Going",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15.h),
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
                    '${DateFormat('d MMM yyyy').format(event!.datetime!)}, ${event?.startTime != null ? eventActionController.formatTime(event!.startTime!) : 'Start'}–${event?.endTime != null ? eventActionController.formatTime(event!.endTime!) : 'Finish'}',
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () => eventActionController
                    .openGoogleMaps(event?.placeName ?? event?.address ?? '-'),
                child: _buildInfoItem(
                  context,
                  icon: SvgPicture.asset(
                    'assets/icons/pin_location.svg',
                    height: 22.h,
                    width: 27.w,
                  ),
                  title: 'Location',
                  subtitle: event?.placeName ?? event?.address ?? '-',
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
                subtitle: (event?.price == null || event?.price == 0)
                    ? 'Free'
                    : NumberHelper().formatCurrency(event!.price!),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Going list
          Obx(() {
            if (controller.isLoadingGoing.value) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade700,
                child: _personGridList(
                  context: context,
                  title: 'Going',
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPersonList(context),
                ),
              );
            }
            return _personGridList(
              context: context,
              title: 'Going',
              seeAll: true,
              itemCount: controller.usersInvites.length > 10
                  ? 10
                  : controller.usersInvites.length,
              itemBuilder: (context, index) => _buildPersonList(
                context,
                controller.usersInvites[index],
              ),
            );
          }),
          SizedBox(height: 15.h),
          // Waitlist
          Obx(() {
            if (controller.isLoadingWaitList.value) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade700,
                child: _personGridList(
                  context: context,
                  title: 'Waitlist',
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPersonList(context),
                ),
              );
            }
            return _personGridList(
              context: context,
              title: 'Waitlist',
              itemCount: controller.usersWaitings.length > 10
                  ? 10
                  : controller.usersWaitings.length,
              itemBuilder: (context, index) => _buildPersonList(
                context,
                controller.usersWaitings[index],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _personGridList(
      {required BuildContext context,
      bool seeAll = false,
      required String title,
      required int itemCount,
      required Widget Function(BuildContext, int) itemBuilder}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title ($itemCount)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Color(0xFFA5A5A5),
                    ),
              ),
              if (seeAll) ...[
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.eventSeeAllParticipant,
                      arguments: {'eventId': event?.id}),
                  child: Row(
                    children: [
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
                          'See all',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFA2FF00),
                            Color(0xFF00FF7F),
                          ],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16.r,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 88 / 115,
            ),
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ],
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

  Widget _buildPersonList(BuildContext context, [EventUserModel? user]) {
    return Container(
      height: 115.h,
      width: 88.w,
      padding: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Color(0xFF4C4C4C),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: user?.user?.imageUrl ?? '',
              width: 35.r,
              height: 35.r,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingCircle(size: 50.r),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 32.r,
                backgroundImage:
                    const AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Text(
              user?.user?.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          if (user?.status == 3) ...[
            Container(
              width: double.infinity,
              height: 25.h,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Text(
                'Reserved',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
