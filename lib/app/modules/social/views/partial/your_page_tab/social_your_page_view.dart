import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_following_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_clubs_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_followers_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_following_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_updates_view.dart';

class SocialYourPageView extends GetView<SocialController> {
  SocialYourPageView({super.key});

  final postController = Get.find<PostController>();
  final followingController = Get.find<SocialFollowingController>();
  final followersController = Get.find<SocialFollowingController>();
  final clubSearchController = Get.find<SocialClubSearchController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedChip.value;

      if (selected == YourPageChip.updates) {
        return RefreshIndicator(
          onRefresh: postController.refreshAllPosts,
          child: SingleChildScrollView(
            controller: postController.postScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                SizedBox(height: 24.h),
                SocialYourPageUpdatesView(),
              ],
            ),
          ),
        );
      } else if (selected == YourPageChip.following) {
        return RefreshIndicator(
          onRefresh: () async {
            followingController.load(refresh: true);
          },
          child: SingleChildScrollView(
            controller: followingController.scrollFriendsController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                SizedBox(height: 24.h),
                const SocialYourPageFollowingView(),
              ],
            ),
          ),
        );
      } else if (selected == YourPageChip.followers) {
        return RefreshIndicator(
          onRefresh: () async {
            followersController.load(refresh: true);
          },
          child: SingleChildScrollView(
            controller: followersController.scrollFriendsController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                SizedBox(height: 24.h),
                const SocialYourPageFollowersView(),
              ],
            ),
          ),
        );
      } else if (selected == YourPageChip.clubs) {
        return RefreshIndicator(
          onRefresh: () async {
            clubSearchController.load(refresh: true);
          },
          child: SingleChildScrollView(
            controller: clubSearchController.scrollClubSearchController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                SizedBox(height: 24.h),
                const SocialYourPageClubsView(),
              ],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChipFilter(context),
            SizedBox(height: 24.h),
            Center(child: Text('No content for "$selected" yet')),
          ],
        ),
      );
    });
  }

  Widget _buildChipFilter(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(context, 'Updates', YourPageChip.updates),
            SizedBox(width: 8.w),
            _buildFilterChip(context, 'Following', YourPageChip.following),
            SizedBox(width: 8.w),
            _buildFilterChip(context, 'Followers', YourPageChip.followers),
            SizedBox(width: 8.w),
            _buildFilterChip(context, 'Clubs', YourPageChip.clubs),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(
      BuildContext context, String label, YourPageChip chipType) {
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
