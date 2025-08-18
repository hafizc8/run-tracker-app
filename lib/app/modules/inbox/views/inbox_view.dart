import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/inbox_page_enum.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_all_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_club_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_event_controller.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_friend_controller.dart';
import 'package:zest_mobile/app/modules/inbox/views/inbox_all_view.dart';
import 'package:zest_mobile/app/modules/inbox/views/inbox_club_view.dart';
import 'package:zest_mobile/app/modules/inbox/views/inbox_event_view.dart';
import 'package:zest_mobile/app/modules/inbox/views/inbox_friend_view.dart';

class InboxView extends GetView<InboxController> {
  InboxView({super.key});

  final allController = Get.find<InboxAllController>();
  final friendController = Get.find<InboxFriendController>();
  final clubController = Get.find<InboxClubController>();
  final eventController = Get.find<InboxEventController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
              ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.chevron_left,
              color: Color(0xFFA5A5A5),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final selected = controller.selectedChip.value;

        if (selected == InboxChip.all) {
          return RefreshIndicator(
            onRefresh: () async => allController.refreshAll(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              controller: allController.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChipFilter(context),
                  SizedBox(height: 24.h),
                  const InboxAllView(),
                ],
              ),
            ),
          );
        }

        if (selected == InboxChip.friends) {
          return RefreshIndicator(
            onRefresh: () async => friendController.refreshFriend(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              controller: friendController.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChipFilter(context),
                  SizedBox(height: 24.h),
                  const InboxFriendView(),
                ],
              ),
            ),
          );
        }

        if (selected == InboxChip.clubs) {
          return RefreshIndicator(
            onRefresh: () async => clubController.refreshClubs(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              controller: clubController.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChipFilter(context),
                  SizedBox(height: 24.h),
                  const InboxClubView(),
                ],
              ),
            ),
          );
        }

        if (selected == InboxChip.event) {
          return RefreshIndicator(
            onRefresh: () async => eventController.refreshEvents(),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              controller: eventController.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChipFilter(context),
                  SizedBox(height: 24.h),
                  const InboxEventView(),
                ],
              ),
            ),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChipFilter(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildChipFilter(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(context, 'All', InboxChip.all),
            SizedBox(width: 8.w),
            _buildFilterChip(context, 'Friends', InboxChip.friends),
            SizedBox(width: 8.w),
            _buildFilterChip(context, 'Clubs', InboxChip.clubs),
            SizedBox(width: 8.w),
            _buildFilterChip(context, 'Event Discussion', InboxChip.event),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(
      BuildContext context, String label, InboxChip chipType) {
    bool isSelected = controller.selectedChip.value == chipType;
    return InkWell(
      onTap: () {
        controller.selectChip(chipType);
      },
      borderRadius: BorderRadius.circular(10.r),
      child: isSelected
          ? Container(
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
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF393939),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ShaderMask(
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
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: const Color(0xFF393939),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFFA5A5A5),
                ),
              ),
            ),
    );
  }
}
