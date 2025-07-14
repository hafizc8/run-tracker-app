import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/leaderboard_top_walkers_page_enum.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_toggle_button.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/controllers/leaderboard_top_walkers_controller.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/widgets/others_walkers.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/widgets/top_3_walkers_list.dart';

class LeaderboardTopWalkersTabView extends GetView<LeaderboardTopWalkersController> {
  LeaderboardTopWalkersTabView({super.key});

  @override
  final controller = Get.put(LeaderboardTopWalkersController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedChip.value;

      if (selected == LeaderboardTopWalkersPageEnum.global) {
        // return RefreshIndicator(
        //   onRefresh: postController.refreshAllPosts,
        //   child: SingleChildScrollView(
        //     controller: postController.postScrollController,
        //     physics: const AlwaysScrollableScrollPhysics(),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         _buildChipFilter(context),
        //         SizedBox(height: 16.h),
        //         SocialYourPageUpdatesView(),
        //       ],
        //     ),
        //   ),
        // );
      } else if (selected == LeaderboardTopWalkersPageEnum.country) {
        // return RefreshIndicator(
        //   onRefresh: () async {
        //     followingController.load(refresh: true);
        //   },
        //   child: SingleChildScrollView(
        //     controller: followingController.scrollFriendsController,
        //     physics: const AlwaysScrollableScrollPhysics(),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         _buildChipFilter(context),
        //         SizedBox(height: 16.h),
        //         const SocialYourPageFollowingView(),
        //       ],
        //     ),
        //   ),
        // );
      } else if (selected == LeaderboardTopWalkersPageEnum.province) {
        // return RefreshIndicator(
        //   onRefresh: () async {
        //     followersController.load(refresh: true);
        //   },
        //   child: SingleChildScrollView(
        //     controller: followersController.scrollFriendsController,
        //     physics: const AlwaysScrollableScrollPhysics(),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         _buildChipFilter(context),
        //         SizedBox(height: 16.h),
        //         const SocialYourPageFollowersView(),
        //       ],
        //     ),
        //   ),
        // );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChipFilter(context),
            const SizedBox(),
            _buildTopWalkersList(context),
          ],
        ),
      );
    });
  }

  Widget _buildChipFilter(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Flexible(
            flex: 30,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(context, 'Global', LeaderboardTopWalkersPageEnum.global),
                  SizedBox(width: 8.w),
                  _buildFilterChip(context, 'Country', LeaderboardTopWalkersPageEnum.country),
                  SizedBox(width: 8.w),
                  _buildFilterChip(context, 'Province', LeaderboardTopWalkersPageEnum.province),
                ],
              ),
            ),
          ),
          const Spacer(flex: 1),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomToggleButton(
                  value: controller.isFriendsOnly.value,
                  onChanged: (newValue) {
                    controller.isFriendsOnly.value = newValue;
                  },
                  activeGradient: const LinearGradient(
                    colors: [
                      Color(0xFFA2FF00),
                      Color(0xFF00FF7F),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Friends\nOnly',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFFA5A5A5),
                    fontSize: 10.5.sp,
                    height: 1.2
                  )
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFilterChip(BuildContext context, String label, LeaderboardTopWalkersPageEnum chipType) {
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
                      fontSize: 11.sp,
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
                  fontSize: 11.sp,
                  color: const Color(0xFFA5A5A5),
                ),
              ),
            ),
    );
  }

  Widget _buildTopWalkersList(BuildContext context) {
    return Column(
      children: [
        Top3WalkersList(
          topWalkers: [
            LeaderboardUserModel(
              rank: 1,
              name: 'James',
              imageUrl: 'https://avatar.iran.liara.run/public/16',
              totalStep: 4999999,
            ),
            LeaderboardUserModel(
              rank: 2,
              name: 'Danny',
              imageUrl: 'https://avatar.iran.liara.run/public/26',
              totalStep: 2999999,
            ),
            LeaderboardUserModel(
              rank: 3,
              name: 'You',
              imageUrl: 'https://avatar.iran.liara.run/public/22',
              totalStep: 1999999,
            ),
          ]
        ),

        // List view
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 15,
          itemBuilder: (context, index) {
            return OthersWalkers(isCurrentUser: index == 3);
          },
        ),
      ],
    );
  }
}