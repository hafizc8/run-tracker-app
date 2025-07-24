import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_event.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';
import 'package:zest_mobile/app/modules/detail_challenge/controllers/detail_challenge_controller.dart';
import 'package:zest_mobile/app/modules/detail_challenge/widgets/card_challenge.dart';
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
            child: Obx(
              () => Visibility(
                visible: controller.detailChallenge.value?.mode == 0,
                child: Visibility(
                  visible: controller.detailChallenge.value?.isJoined == 1,
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
                          'Leaderboard',
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
                                    GridView(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 71 / 90,
                                      ),
                                      children: [
                                        ...(List.generate(teams.length, (i) {
                                          final e = teams[i];

                                          return AspectRatio(
                                            aspectRatio: 71 / 90,
                                            child: Container(
                                              padding: EdgeInsets.all(8.w),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF3C3C3C),
                                                borderRadius:
                                                    BorderRadius.circular(10.w),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          e.user?.imageUrl ??
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
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onBackground,
                                                        child: Text(
                                                          (e.user?.name ?? '')
                                                              .toInitials(),
                                                          style:
                                                              Theme.of(context)
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        })),
                                        Visibility(
                                          visible: teams.every(
                                            (element) =>
                                                element.user?.id !=
                                                controller.userId,
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {},
                                            child: AspectRatio(
                                              aspectRatio: 71 / 90,
                                              child: Container(
                                                padding: EdgeInsets.all(1.w),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFFA2FF00),
                                                      Color(0xFF00FF7F),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11.r),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                    width: 24.r,
                                                    height: 24.r,
                                                    'assets/icons/ic_switch_user.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        })
                      ],
                      if (controller.detailChallenge.value?.isOwner == 1) ...[
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
                            SvgPicture.asset('assets/icons/ic_add2.svg'),
                          ],
                        )
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
