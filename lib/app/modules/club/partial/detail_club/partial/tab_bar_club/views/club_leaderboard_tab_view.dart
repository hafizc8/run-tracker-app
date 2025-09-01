import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_leaderboard_tab_controller.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/widgets/others_walkers.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/widgets/top_3_walkers_list.dart';

class ClubLeaderboardTabView extends GetView<ClubLeaderboardTabController> {
  const ClubLeaderboardTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                _buildTopWalkersList(context),
                SizedBox(height: 80.h),
              ],
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
        ),
      ),
    );
  }

  Widget _buildTopWalkersList(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoadingGetLeaderboard.value && controller.pageLeaderboard.value == 1) {
          // return const LeaderboardShimmerEffect();
          return const SizedBox();
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