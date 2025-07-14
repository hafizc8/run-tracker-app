import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/step_tracker_widget.dart';
import 'package:zest_mobile/app/modules/home/views/widget/home_shimmer_layout.dart';
import 'package:zest_mobile/app/modules/home/widgets/custom_exp_progress_bar.dart';
import 'package:zest_mobile/app/modules/home/widgets/walker_profile.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingGetUserData.value) {
          return const HomeShimmerEffect();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Widget Profile
                // Container(
                //   margin: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                //   child: Row(
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Hello,',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .titleSmall
                //                 ?.copyWith(
                //                   fontSize: 20.sp,
                //                 ),
                //           ),
                //           Text(
                //             '${controller.user?.name}',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .titleSmall
                //                 ?.copyWith(
                //                   fontSize: 20.sp,
                //                   fontWeight: FontWeight.w700,
                //                 ),
                //           ),
                //         ],
                //       ),
                //       const Spacer(),
                //       InkWell(
                //         onTap: () {
                //           Get.snackbar(
                //               'Coming Soon', 'Feature will be added soon',
                //               backgroundColor: Colors.green,
                //               colorText: Colors.white);
                //         },
                //         child: Container(
                //           decoration: const BoxDecoration(
                //             color: Color(0xFF494949),
                //             shape: BoxShape.circle,
                //           ),
                //           padding: EdgeInsets.all(13.w),
                //           child: FaIcon(
                //             FontAwesomeIcons.solidBell,
                //             color: Colors.white,
                //             size: 18.sp,
                //           ),
                //         ),
                //       ),
                //       SizedBox(width: 12.w),
                //       InkWell(
                //         onTap: () {
                //           Get.snackbar(
                //               'Coming Soon', 'Feature will be added soon',
                //               backgroundColor: Colors.green,
                //               colorText: Colors.white);
                //         },
                //         child: Container(
                //           decoration: const BoxDecoration(
                //             color: Color(0xFF494949),
                //             shape: BoxShape.circle,
                //           ),
                //           padding: EdgeInsets.all(12.w),
                //           child: FaIcon(
                //             FontAwesomeIcons.solidEnvelope,
                //             color: Colors.white,
                //             size: 18.sp,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // // Level
                // Container(
                //   margin: EdgeInsets.only(left: 16.w, top: 10.h),
                //   child: Row(
                //     children: [
                //       Text(
                //           'Level ${controller.user?.currentUserXp?.currentLevel}',
                //           style: Theme.of(context).textTheme.headlineSmall),
                //       SizedBox(width: 8.w),
                //       // Widget Progress bar exp
                //       SizedBox(
                //         width: MediaQuery.of(context).size.width * 0.3,
                //         child: CustomExpProgressBar(
                //           currentExp:
                //               controller.user?.currentUserXp?.currentAmount ??
                //                   0,
                //           maxExp: controller.user?.currentUserXp?.levelDetail
                //                   ?.xpNeeded ??
                //               0,
                //           height: 15,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // // coin & energy
                // Container(
                //   margin:
                //       EdgeInsets.only(left: 16.w, top: 14.h, bottom: 10.h),
                //   child: Row(
                //     children: [
                //       Row(
                //         children: [
                //           SvgPicture.asset(
                //             'assets/icons/ic_coin.svg',
                //             width: 16.w,
                //           ),
                //           SizedBox(width: 4.w),
                //           Text(
                //             '${controller.user?.currentUserCoin?.currentAmount ?? 0}',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headlineSmall
                //                 ?.copyWith(
                //                   fontSize: 14.sp,
                //                   fontWeight: FontWeight.w700,
                //                   fontStyle: FontStyle.italic,
                //                   letterSpacing: 1.0,
                //                 ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(width: 20.w),
                //       Row(
                //         children: [
                //           SvgPicture.asset(
                //             'assets/icons/ic_energy.svg',
                //             height: 16.w,
                //           ),
                //           SizedBox(width: 4.w),
                //           Text(
                //             '${controller.user?.currentUserStamina?.currentAmount ?? 0}/${controller.user?.currentUserXp?.levelDetail?.staminaIncreaseTotal ?? 0}',
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headlineSmall
                //                 ?.copyWith(
                //                   fontSize: 14.sp,
                //                   fontWeight: FontWeight.w700,
                //                   fontStyle: FontStyle.italic,
                //                   letterSpacing: 1.0,
                //                 ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),

                // // Widget Step Tracker
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 32.w),
                //   child: StepsTrackerWidget(
                //     progressValue: controller.progressValue,
                //     currentSteps: controller.validatedSteps,
                //     maxSteps: controller.user?.userPreference?.dailyStepGoals ?? 0,
                //   ),
                // ),
                // // Error message when step sensor not found
                // Obx(() {
                //   return Visibility(
                //     visible: (controller.error.isNotEmpty),
                //     child: Container(
                //       margin: EdgeInsets.only(bottom: 8.h),
                //       child: Text(
                //         controller.error,
                //         style:
                //             Theme.of(context).textTheme.titleSmall?.copyWith(
                //                   color: Colors.red.shade400,
                //                   fontSize: 13.sp,
                //                   fontStyle: FontStyle.italic,
                //                 ),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   );
                // }),
                // Container(
                //   width: double.infinity,
                //   margin: EdgeInsets.only(left: 16.w, right: 24.w,),
                //   child: Row(
                //     children: [
                //       Flexible(
                //         flex: 1,
                //         child: GestureDetector(
                //           // Widget ikon Anda
                //           child: SizedBox(
                //             width: 21.w + 6,
                //             height: 21.w + 19,
                //             child: Stack(
                //               children: [
                //                 SvgPicture.asset(
                //                   'assets/icons/ic_streak.svg',
                //                   width: 21.w,
                //                 ),
                //                 Obx(() {
                //                   if (controller.homePageData.value?.recordDailyStreakCount == 0) {
                //                     return const SizedBox();
                //                   }

                //                   return Positioned(
                //                     right: 0,
                //                     bottom: 0,
                //                     child: Container(
                //                       decoration: const BoxDecoration(
                //                         shape: BoxShape.circle,
                //                         color: Colors.white,
                //                       ),
                //                       padding: const EdgeInsets.all(6),
                //                       child: Text(
                //                         '${controller.homePageData.value?.recordDailyStreakCount ?? 0}',
                //                         style: GoogleFonts.poppins(
                //                           fontSize: 10.sp,
                //                           fontWeight: FontWeight.w700,
                //                           color: const Color(0xFF292929),
                //                         ),
                //                       ),
                //                     ),
                //                   );
                //                 }),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //       Flexible(
                //         flex: 8,
                //         child: Column(
                //           children: [
                //             Text(
                //               'Just ${NumberHelper().formatNumberToKWithComma((controller.user?.userPreference?.dailyStepGoals ?? 0) - controller.validatedSteps)} steps left to crush your goal!',
                //               style: Theme.of(context).textTheme.titleSmall,
                //               textAlign: TextAlign.center,
                //             ),
                //             SizedBox(height: 18.h),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/ic_time.svg',
                //                       width: 15.w,
                //                     ),
                //                     SizedBox(width: 8.w),
                //                     Obx(
                //                       () {
                //                         return Text(
                //                           '${NumberHelper().secondsToMinutes(controller.totalActiveTimeInSeconds)} Mins',
                //                           style: Theme.of(context)
                //                               .textTheme
                //                               .titleSmall
                //                               ?.copyWith(
                //                                 fontSize: 12.5.sp,
                //                               ),
                //                         );
                //                       }
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(width: 20.w),
                //                 Row(
                //                   children: [
                //                     SvgPicture.asset(
                //                       'assets/icons/ic_calories.svg',
                //                       width: 15.w,
                //                     ),
                //                     SizedBox(width: 8.w),
                //                     Text(
                //                       '0 Cal',
                //                       style: Theme.of(context)
                //                           .textTheme
                //                           .titleSmall
                //                           ?.copyWith(
                //                             fontSize: 12.5.sp,
                //                           ),
                //                     ),
                //                   ],
                //                 ),
                //                 SizedBox(width: 20.w),
                //                 SvgPicture.asset(
                //                   'assets/icons/ic_share_3.svg',
                //                   width: 21.w,
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // SizedBox(height: 24.h),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment
                //       .start, // Agar judul "Top Walkers" rata kiri
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: 16.0.w),
                //       child: Text(
                //         'Top Walkers',
                //         style: Theme.of(context).textTheme.titleSmall,
                //       ),
                //     ),
                //     SizedBox(height: 12.h),
                //     Obx(() {
                //       // Ambil data leaderboards dari controller
                //       final leaderboards = controller.homePageData.value?.leaderboards;
                //       final currentUser = controller.user;

                //       // Tampilkan container kosong jika data belum siap
                //       if (leaderboards == null || leaderboards.isEmpty || currentUser == null) {
                //         return const SizedBox(height: 145);
                //       }

                //       // Cari data dan indeks peringkat dari pengguna yang sedang login
                //       final currentUserLeaderboardData =
                //           leaderboards.firstWhereOrNull((leader) => leader.id == currentUser.id);
                //       final currentUserRankIndex =
                //           leaderboards.indexWhere((leader) => leader.id == currentUser.id);

                //       // Helper function untuk format rank
                //       String formatRank(int? rank) {
                //         if (rank == null) return '-';
                //         if (rank == 1) return '1st';
                //         if (rank == 2) return '2nd';
                //         if (rank == 3) return '3rd';
                //         if (rank % 10 == 1 && rank % 100 != 11) return '${rank}st';
                //         if (rank % 10 == 2 && rank % 100 != 12) return '${rank}nd';
                //         if (rank % 10 == 3 && rank % 100 != 13) return '${rank}rd';
                //         return '${rank}th';
                //       }

                //       /// Widget untuk tombol "See More"
                //       Widget buildSeeMoreButton() {
                //         return GestureDetector(
                //           onTap: () {
                //             Get.snackbar("Coming soon", "Navigate to full leaderboard page.");
                //           },
                //           child: Container(
                //             height: 126.h,
                //             decoration: BoxDecoration(
                //               color: const Color(0xFF393939),
                //               borderRadius: BorderRadius.circular(12.r),
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 const Icon(Icons.arrow_forward_ios, size: 24),
                //                 SizedBox(height: 8.h),
                //                 Text(
                //                   "See more",
                //                   style: Theme.of(Get.context!).textTheme.titleSmall?.copyWith(fontSize: 12.sp),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       }

                //       return Container(
                //         width: 398.w,
                //         decoration: BoxDecoration(
                //           color: darkColorScheme.surface,
                //           borderRadius: BorderRadius.circular(12.r),
                //         ),
                //         margin: EdgeInsets.symmetric(horizontal: 16.w),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             // ✨ KUNCI: Gunakan kondisi untuk menentukan widget yang akan di-render ✨
                //             if (currentUserRankIndex != -1 && currentUserRankIndex < 3)
                //               // --- TAMPILAN JIKA USER TOP 3 ---
                //               ...leaderboards.take(3).map((walker) {
                //                 final bool isCurrentUser = walker.id == currentUser.id;
                //                 return Expanded(
                //                   child: WalkerProfile(
                //                     rank: formatRank(walker.rank),
                //                     name: isCurrentUser ? 'Your' : (walker.name ?? '-'),
                //                     imageUrl: walker.imageUrl ?? '',
                //                   ),
                //                 );
                //               }).toList(),
                //             if (currentUserRankIndex != -1 && currentUserRankIndex < 3)
                //               // --- Tombol "See More" ---
                //               Expanded(
                //                 child: buildSeeMoreButton(),
                //               ),

                //             if (currentUserRankIndex == -1 || currentUserRankIndex >= 3)
                //               // --- TAMPILAN JIKA USER BUKAN TOP 3 ---
                //               ...() {
                //                 final otherWalkers = leaderboards.where((leader) => leader.id != currentUser.id).toList();
                //                 final top3OtherWalkers = otherWalkers.take(3).toList();
                //                 final walkersToShow = [...top3OtherWalkers];
                //                 if (currentUserLeaderboardData != null) {
                //                   walkersToShow.add(currentUserLeaderboardData);
                //                 }

                //                 return walkersToShow.map((walker) {
                //                   final bool isCurrentUser = walker.id == currentUser.id;
                //                   return Expanded(
                //                     child: WalkerProfile(
                //                       rank: formatRank(walker.rank),
                //                       name: isCurrentUser ? 'Your' : (walker.name ?? '-'),
                //                       imageUrl: walker.imageUrl ?? (isCurrentUser ? currentUser.imageUrl ?? '' : ''),
                //                       backgroundColor: isCurrentUser ? const Color(0xFF393939) : null,
                //                     ),
                //                   );
                //                 }).toList();
                //               }(),
                //           ],
                //         ),
                //       );
                //     }),
                //   ],
                // ),

                // SizedBox(height: 12.h),

                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.challengeCreate);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: darkColorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Text(
                          'Challenge Your Friends!',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const Spacer(),
                        const FaIcon(
                          FontAwesomeIcons.circlePlus,
                          color: Color(0xFF5A5A5A),
                          size: 38,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 36.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
