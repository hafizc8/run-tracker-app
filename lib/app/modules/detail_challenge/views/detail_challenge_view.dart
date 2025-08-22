import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_team_model.dart';

import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_event.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';
import 'package:zest_mobile/app/modules/detail_challenge/controllers/detail_challenge_controller.dart';
import 'package:zest_mobile/app/modules/detail_challenge/widgets/card_challenge.dart';
import 'package:zest_mobile/app/modules/detail_challenge/widgets/leaderboard_other.dart';
import 'package:zest_mobile/app/modules/detail_challenge/widgets/leaderboard_top.dart';

import 'package:zest_mobile/app/routes/app_routes.dart';

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
              visible: (controller.detailChallenge.value?.isOwner == 1 &&
                  (controller.detailChallenge.value?.startDate!
                          .isFutureDate() ==
                      true)),
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  // Handle the selection
                  if (value == 'edit_challenge') {
                    var res = await Get.toNamed(AppRoutes.challengeEdit,
                        arguments: controller.detailChallenge.value);
                    if (res != null) {
                      controller.challengeId = res.id!;
                      controller.load();
                    }
                  } else if (value == 'cancel_challenge') {
                    controller.confirmCancel();
                  }
                },
                surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit_challenge',
                      child: Text(
                        'Edit Challenge',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'invite_friend',
                      child: Text(
                        'Invite A Friend',
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
            child: Obx(() {
              if (controller.detailChallenge.value?.type == 0 &&
                  controller.detailChallenge.value?.isJoined == 0) {
                return Obx(
                  () => SizedBox(
                    height: 43.h,
                    child: GradientOutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11.r),
                          ),
                        ),
                      ),
                      onPressed: controller.isLoadingJoin.value
                          ? null
                          : () {
                              controller.join();
                            },
                      child: Visibility(
                        visible: !controller.isLoadingJoin.value,
                        replacement: CustomCircularProgressIndicator(),
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
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Visibility(
                visible: controller.detailChallenge.value?.startDate!
                        .isFutureDate() ==
                    true,
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
              );
            }),
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
                      Obx(
                        () => CardChallenge(
                          challengeDetailModel:
                              controller.detailChallenge.value!,
                        ),
                      ),
                      if (controller.detailChallenge.value?.type == 0) ...[
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Participants',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFA5A5A5),
                                    fontSize: 15.sp,
                                  ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Obx(() {
                          if (controller.isLoadingParticipants.value) {
                            return const CircularProgressIndicator();
                          }
                          return ParticipantsAvatars(
                            imageUrls: controller.participants.value
                                .map((e) => e.user?.imageUrl ?? 'null')
                                .toList(),
                            avatarSize: 29,
                            overlapOffset: 38,
                            maxVisible: 3,
                          );
                        })
                      ],
                      if (controller.detailChallenge.value?.type == 1) ...[
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Teams',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFA5A5A5),
                                    fontSize: 15.sp,
                                  ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Obx(() {
                          if (controller.isLoadingTeams.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children:
                                controller.teams.value.entries.map((entry) {
                              final teamKey = entry.key;
                              final teams = entry.value;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      teamKey,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontSize: 15.sp,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (!(controller.detailChallenge.value
                                                ?.startDate!
                                                .isFutureDate() ==
                                            true) &&
                                        teams.any((element) =>
                                            element.user?.id ==
                                            controller.userId)) ...[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Your Team Progress',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFFA5A5A5),
                                                  fontSize: 12.sp,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          ProgressWidget(
                                            currentSteps: controller
                                                    .detailChallenge
                                                    .value
                                                    ?.teamProgress ??
                                                0,
                                            targetSteps: controller
                                                    .detailChallenge
                                                    .value
                                                    ?.target ??
                                                0,
                                            startDate: controller
                                                        .detailChallenge
                                                        .value
                                                        ?.mode ==
                                                    1
                                                ? controller.detailChallenge
                                                    .value?.startDate
                                                : null,
                                            endDate: controller.detailChallenge
                                                        .value?.mode ==
                                                    1
                                                ? controller.detailChallenge
                                                    .value?.endDate
                                                : null,
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      )
                                    ],
                                    SizedBox(
                                      height: 90.h,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Visibility(
                                            visible: teams.every(
                                                  (element) =>
                                                      element.user?.id !=
                                                      controller.userId,
                                                ) &&
                                                controller.detailChallenge.value
                                                        ?.startDate!
                                                        .isFutureDate() ==
                                                    true,
                                            child: Obx(
                                              () => GestureDetector(
                                                onTap: controller
                                                        .isLoadingJoin.value
                                                    ? null
                                                    : () async {
                                                        controller.join(
                                                          toTeam: teamKey,
                                                        );
                                                      },
                                                child: AspectRatio(
                                                  aspectRatio: 71 / 90,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(1.w),
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFFA2FF00),
                                                          Color(0xFF00FF7F),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              11.r),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Visibility(
                                                        visible: controller
                                                                .teamName ==
                                                            teamKey,
                                                        replacement:
                                                            SvgPicture.asset(
                                                          width: 24.r,
                                                          height: 24.r,
                                                          'assets/icons/ic_switch_user.svg',
                                                        ),
                                                        child:
                                                            CustomCircularProgressIndicator(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ...(List.generate(teams.length, (i) {
                                            final e = teams[i];

                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.w),
                                              child: AspectRatio(
                                                aspectRatio: 71 / 90,
                                                child: Container(
                                                  padding: EdgeInsets.all(8.w),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF3C3C3C),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.w),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: e.user
                                                                  ?.imageUrl ??
                                                              '',
                                                          width: 32.r,
                                                          height: 32.r,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              ShimmerLoadingCircle(
                                                            size: 32.r,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              CircleAvatar(
                                                            radius: 32.r,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                            child: Text(
                                                              (e.user?.name ??
                                                                      '')
                                                                  .toInitials(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .background,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        e.user?.name ?? '-',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        })
                      ],
                      if ((controller.detailChallenge.value?.isOwner == 1 ||
                              controller.detailChallenge.value?.isJoined ==
                                  1) &&
                          controller.detailChallenge.value?.startDate!
                                  .isFutureDate() ==
                              true) ...[
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Invited',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFA5A5A5),
                                    fontSize: 15.sp,
                                  ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Obx(() {
                              if (controller.isLoadingInvited.value) {
                                return const CircularProgressIndicator();
                              }
                              return ParticipantsAvatars(
                                imageUrls: controller.invited.value
                                    .map((e) => e.user?.imageUrl ?? 'null')
                                    .toList(),
                                avatarSize: 29,
                                overlapOffset: 38,
                                maxVisible: 3,
                              );
                            }),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                var res = await Get.toNamed(
                                    AppRoutes.challengedetailsInvite,
                                    arguments: {
                                      'challengeId': controller.challengeId
                                    });
                                if (res != null &&
                                    res is List<ChallengeTeamsModel>) {
                                  controller.invited.value = [
                                    ...controller.invited.value..addAll(res)
                                  ];
                                }
                              },
                              child:
                                  SvgPicture.asset('assets/icons/ic_add2.svg'),
                            ),
                          ],
                        )
                      ] else ...[
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text(
                              'Leaderboard',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFA5A5A5),
                                    fontSize: 15.sp,
                                  ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                if (controller.detailChallenge.value?.type == 0) {
                                  Get.toNamed(AppRoutes.shareChallengeProgressIndividual, arguments:controller.detailChallenge.value);
                                } else {
                                  Get.toNamed(AppRoutes.shareChallengeProgressTeam, arguments: {
                                    'detailChallenge': controller.detailChallenge.value,
                                    'team': controller.teams.value
                                  });
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/icons/ic_share-2.svg',
                                height: 24.r,
                                width: 24.r,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (controller.detailChallenge.value?.type == 1) ...[
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (controller.detailChallenge.value
                                        ?.leaderboardTeams ??
                                    [])
                                .length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemBuilder: (context, index) {
                              LeaderboardTeam item = (controller.detailChallenge
                                      .value?.leaderboardTeams ??
                                  [])[index];
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        NumberHelper().formatRank(item.rank),
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFA5A5A5),
                                              fontSize: 15.sp,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        item.team ?? '-',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFFA5A5A5),
                                              fontSize: 15.sp,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  item.point?.toString() ?? '-',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15.sp,
                                      ),
                                ),
                              );
                            },
                          )
                        ] else ...[
                          Obx(() {
                            final otherWalkersList = (controller.detailChallenge
                                            .value?.leaderboardUsers.length ??
                                        0) >
                                    3
                                ? controller
                                    .detailChallenge.value?.leaderboardUsers
                                    .sublist(3)
                                : <LeaderboardUser>[];

                            return Column(
                              children: [
                                Top3LeaderBoardIndividualList(
                                    topWalkers: controller.detailChallenge.value
                                            ?.leaderboardUsers ??
                                        <LeaderboardUser>[].take(3).toList()),

                                // List view
                                (controller.detailChallenge.value
                                                ?.leaderboardUsers.length ??
                                            0) >
                                        3
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: otherWalkersList?.length,
                                        itemBuilder: (context, index) {
                                          return ChallengeOthersWalkers(
                                            walker: otherWalkersList?[index],
                                            isCurrentUser: false,
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            );
                          })
                        ]
                      ],
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

class ProgressWidget extends StatelessWidget {
  final int currentSteps;
  final int? targetSteps;
  final DateTime? startDate;
  final DateTime? endDate;

  const ProgressWidget({
    super.key,
    required this.currentSteps,
    this.targetSteps,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    double progress = 0;
    String label = '';

    if (targetSteps != null && targetSteps! > 0) {
      // 👉 Step-based progress
      progress = (currentSteps / targetSteps!).clamp(0.0, 1.0);
      label = '$currentSteps / $targetSteps Steps';
    } else if (startDate != null && endDate != null) {
      // 👉 Date-based progress (inclusive)
      final start = DateTime(startDate!.year, startDate!.month, startDate!.day);
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day);

      final totalDays = end.difference(start).inDays + 1; // inclusive
      final daysRemaining =
          (end.difference(today).inDays + 1).clamp(0, totalDays);
      final daysPassed = (totalDays - daysRemaining).clamp(0, totalDays);

      progress = (daysPassed / totalDays).clamp(0.0, 1.0);
      label = '$currentSteps Steps / $daysRemaining Days Remaining';
    } else {
      label = 'Invalid configuration';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Background bar
            Container(
              height: 15,
              decoration: BoxDecoration(
                color: Color(0xFF595959),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Foreground gradient bar
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 15,
                decoration: BoxDecoration(
                  gradient: kAppDefaultButtonGradient,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}
