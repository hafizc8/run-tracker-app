import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zest_mobile/app/core/models/enums/leaderboard_top_walkers_page_enum.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_toggle_button.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/controllers/leaderboard_top_walkers_controller.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/widgets/leaderboard_shimmer_layout.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/widgets/others_walkers.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/widgets/top_3_walkers_list.dart';

class LeaderboardTopWalkersTabView extends GetView<LeaderboardTopWalkersController> {
  LeaderboardTopWalkersTabView({super.key});

  @override
  final controller = Get.put(LeaderboardTopWalkersController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            controller.refreshLeaderboard();
          },
          child: SingleChildScrollView(
            controller: controller.leaderboardScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                const SizedBox(),
                Obx(
                  () {
                    if (controller.areaFilter.value.isEmpty) {
                      return const SizedBox();
                    }

                    return Container(
                      margin: EdgeInsets.only(top: 20.h, bottom: 0.h, right: 5.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          controller.areaFilter.value,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFFA5A5A5),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  }
                ),
                _buildTopWalkersList(context),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),

        Obx(
          () {
            if (controller.isLoadingGetLeaderboard.value && controller.pageLeaderboard.value == 1) {
              return const SizedBox();
            }

            return _buildFloatingRank(context);
          }
        ),
      ],
    );
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
                  SizedBox(width: 8.w),
                  _buildFilterChip(context, 'Regency', LeaderboardTopWalkersPageEnum.regency),
                  SizedBox(width: 8.w),
                  _buildFilterChip(context, 'District', LeaderboardTopWalkersPageEnum.district),
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
                    controller.refreshLeaderboard();
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
    return Obx(
      () {
        if (controller.isLoadingGetLeaderboard.value && controller.pageLeaderboard.value == 1) {
          return const LeaderboardShimmerEffect();
        }

        LeaderboardUserModel? me = controller.me.value;

        final otherWalkersList = controller.leaderboards.length > 3
          ? controller.leaderboards.sublist(3)
          : <LeaderboardUserModel>[];

        return Column(
          children: [
            Top3WalkersList(
              topWalkers: controller.leaderboards.take(3).toList().map((e) {
                return e.copyWith(
                  name: (me?.rank == e.rank) ? 'You' : e.name
                );
              }).toList(),
            ),

            // List view
            controller.leaderboards.length > 3
            ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: otherWalkersList.length + (controller.hasReacheMax.value ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == otherWalkersList.length && !controller.hasReacheMax.value) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final walker = otherWalkersList[index];
                final bool isCurrentUser = (me?.rank == walker.rank);

                // ✨ KUNCI: Bungkus item user dengan VisibilityDetector ✨
                if (isCurrentUser) {
                  return VisibilityDetector(
                    key: const Key('my_rank_in_list'),
                    onVisibilityChanged: (visibilityInfo) {
                      bool isVisible = visibilityInfo.visibleFraction > 0.1;
                      controller.onMyRankVisibilityChanged(isVisible);
                    },
                    child: OthersWalkers(
                      walker: walker,
                      isCurrentUser: true,
                    ),
                  );
                }

                return OthersWalkers(
                  walker: walker,
                  isCurrentUser: false,
                );
              },
            )
            : const SizedBox.shrink(),
          ],
        );
      }
    );
  }

  Widget _buildFloatingRank(BuildContext context) {
    return Obx(() {
      final me = controller.me.value;

      // Gunakan AnimatedPositioned untuk animasi muncul/hilang yang mulus
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        // Posisikan di bawah layar jika disembunyikan, atau di atas jika ditampilkan
        bottom: controller.showFloatingRank.value ? 16.h : -100.h,
        left: 0,
        right: 0,
        child: (me != null)
            ? Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12.r),
                child: OthersWalkers(
                  walker: me,
                  isCurrentUser: true,
                  isFloating: true,
                ),
              )
            : const SizedBox.shrink(),
      );
    });
  }
}