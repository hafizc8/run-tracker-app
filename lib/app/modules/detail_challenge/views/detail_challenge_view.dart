import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_event.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';
import 'package:zest_mobile/app/modules/detail_challenge/controllers/detail_challenge_controller.dart';
import 'package:zest_mobile/app/modules/detail_challenge/widgets/card_challenge.dart';

class DetailChallengeView extends GetView<DetailChallangeController> {
  const DetailChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Challenge Details',
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
        actions: [
          Obx(
            () => Visibility(
              visible: controller.detailChallenge.value?.isOwner == 1,
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  // Handle the selection
                  if (value == 'edit_challenge') {
                  } else if (value == 'cancel_challenge') {}
                },
                surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit_challenge',
                      child: Text(
                        'Edit Event',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'cancel_challenge',
                      child: Visibility(
                        visible: false,
                        replacement: Text(
                          'Cancel Challenge',
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
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SvgPicture.asset(
                    'assets/icons/ic_more_horiz.svg',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          replacement: const SizedBox(),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Obx(
              () => Visibility(
                visible: controller.detailChallenge.value?.isOwner == 1,
                replacement: SizedBox(
                  height: 43.h,
                  child: GradientOutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                      ),
                    ),
                    onPressed: () {},
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
                        'Join Challenge',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 43.h,
                  child: GradientOutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                      ),
                    ),
                    onPressed: () {},
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
                        'Share',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Obx(
          () => Visibility(
            visible: controller.isLoading.value,
            replacement: controller.detailChallenge.value != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardChallenge(
                        challengeDetailModel: controller.detailChallenge.value!,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Leaderboard',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA5A5A5),
                              fontSize: 15.sp,
                            ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Rewards',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA5A5A5),
                              fontSize: 15.sp,
                            ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/images/empty_reward.svg',
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "As a finisher you will earn a digital finisher's badge for your Trophy Case.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFA5A5A5),
                                  fontSize: 12.sp,
                                ),
                          ),
                        ],
                      ),
                      // Text(
                      //   'Invited',
                      //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //         fontWeight: FontWeight.w400,
                      //         color: Color(0xFFA5A5A5),
                      //         fontSize: 15.sp,
                      //       ),
                      // ),
                      // Row(
                      //   children: [
                      //     const Spacer(),
                      //     SvgPicture.asset(
                      //       'assets/icons/ic_add.svg',
                      //       color: Theme.of(context).colorScheme.onBackground,
                      //       height: 22.h,
                      //       width: 27.w,
                      //     ),
                      //   ],
                      // )
                    ],
                  )
                : const SizedBox(),
            child: const EventShimmer(),
          ),
        ),
      ),
    );
  }
}
