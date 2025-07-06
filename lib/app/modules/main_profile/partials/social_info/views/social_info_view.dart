import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_info_page_enum.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_clubs.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_followers.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_following.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/views/social_info_clubs_view.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/views/social_info_followers_view.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/views/social_info_following_view.dart';

class SocialInfoView extends GetView<SocialInfoController> {
  SocialInfoView({super.key});

  final followingController = Get.find<SocialInfoFollowingController>();
  final followersController = Get.find<SocialInfoFollowersController>();
  final clubsController = Get.find<SocialInfoClubsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.name.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Color(0xFFA5A5A5),
                ),
          ),
        ),
        automaticallyImplyLeading: false,
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
        late ScrollController scrollController;
        switch (controller.selectedChip.value) {
          case YourPageChip.following:
            scrollController = followingController.scrollFriendsController;

            break;
          case YourPageChip.followers:
            scrollController = followersController.scrollFriendsController;

            break;
          case YourPageChip.clubs:
            scrollController = clubsController.scrollClubSearchController;

            break;
          default:
        }
        return RefreshIndicator(
          onRefresh: () async {
            switch (controller.selectedChip.value) {
              case YourPageChip.following:
                followingController.load(refresh: true);
                break;
              case YourPageChip.followers:
                followersController.load(refresh: true);
                break;
              case YourPageChip.clubs:
                clubsController.load(refresh: true);
                break;
              default:
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                SizedBox(height: 24.h),
                Obx(() {
                  switch (controller.selectedChip.value) {
                    case YourPageChip.following:
                      return SocialInfoFollowingView();
                    case YourPageChip.followers:
                      return const SocialInfoFollowersView();
                    case YourPageChip.clubs:
                      return const SocialInfoClubsView();

                    default:
                      return const SizedBox();
                  }
                })
              ],
            ),
          ),
        );
      }),
    );
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
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
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

  Widget _buildChipFilter(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterChip(context, 'Following', YourPageChip.following),
          SizedBox(width: 8.w),
          _buildFilterChip(context, 'Followers', YourPageChip.followers),
          SizedBox(width: 8.w),
          _buildFilterChip(context, 'Clubs', YourPageChip.clubs),
        ],
      );
    });
  }
}
