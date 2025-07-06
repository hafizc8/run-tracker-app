import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_clubs.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_followers.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_following.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/card_activity/card_activity.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/controllers/profile_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Container(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        width: double.infinity,
                        height: 256.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                      .user.value?.imageUrl ??
                                                  '',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const ShimmerLoadingCircle(
                                                      size: 50),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const CircleAvatar(
                                                radius: 32,
                                                backgroundImage: AssetImage(
                                                    'assets/images/empty_profile.png'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.58),
                                                child: Text(
                                                  controller.user.value?.name ??
                                                      '-',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground,
                                                      ),
                                                ),
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.58),
                                                child: Text(
                                                  '${controller.user.value?.province ?? '-'}, ${controller.user.value?.country ?? '-'}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          fontSize: 13,
                                                          color: const Color(
                                                              0xFF6C6C6C)),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.58,
                                      ),
                                      child: Text(
                                        controller.user.value?.bio ?? 'No bio',
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Visibility(
                                      visible: controller.user.value?.id !=
                                          controller.currentUser?.id,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.58,
                                        ),
                                        child: Row(
                                          children: [
                                            Visibility(
                                              visible: controller.user.value
                                                      ?.isFollowing ==
                                                  0,
                                              replacement:
                                                  GradientOutlinedButton(
                                                onPressed: () {
                                                  controller.unfollow();
                                                },
                                                child: Row(children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.userCheck,
                                                    size: 13,
                                                    color: darkColorScheme
                                                        .background,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'Following',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                darkColorScheme
                                                                    .background),
                                                  ),
                                                ]),
                                              ),
                                              child: GradientOutlinedButton(
                                                onPressed: () {
                                                  controller.follow();
                                                },
                                                child: Row(children: [
                                                  const Icon(
                                                    Icons.person_add_alt_1,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'Follow',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () => Get.snackbar(
                                                  'Coming Soon',
                                                  'Feature coming soon'),
                                              child: SvgPicture.asset(
                                                'assets/icons/msg.svg',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: InkWell(
                          onTap: () => Get.snackbar(
                              'Coming Soon', 'Feature coming soon'),
                          child: SvgPicture.asset(
                            'assets/icons/ic_share-2.svg',
                            width: 26.w,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Color(0xFF404040),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.delete<SocialInfoController>();
                                      Get.delete<
                                          SocialInfoFollowingController>();
                                      Get.delete<
                                          SocialInfoFollowersController>();
                                      Get.delete<SocialInfoClubsController>();
                                      Get.toNamed(
                                        AppRoutes.profileSocialInfo,
                                        arguments: {
                                          'name': controller.user.value?.name,
                                          'id': controller.user.value?.id,
                                          'page': 0
                                        },
                                        preventDuplicates: false,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Following',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                              ),
                                        ),
                                        ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFA2FF00),
                                              Color(0xFF00FF7F),
                                            ],
                                          ).createShader(
                                            Rect.fromLTWH(0, 0, bounds.width,
                                                bounds.height),
                                          ),
                                          child: Text(
                                            '${controller.user.value?.followingCount ?? 0}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20.sp,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.delete<SocialInfoController>();
                                      Get.delete<
                                          SocialInfoFollowingController>();
                                      Get.delete<
                                          SocialInfoFollowersController>();
                                      Get.delete<SocialInfoClubsController>();
                                      Get.toNamed(
                                        AppRoutes.profileSocialInfo,
                                        arguments: {
                                          'name': controller.user.value?.name,
                                          'id': controller.user.value?.id,
                                          'page': 1,
                                        },
                                        preventDuplicates: false,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Followers',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                              ),
                                        ),
                                        ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFA2FF00),
                                              Color(0xFF00FF7F),
                                            ],
                                          ).createShader(
                                            Rect.fromLTWH(0, 0, bounds.width,
                                                bounds.height),
                                          ),
                                          child: Text(
                                            '${controller.user.value?.followersCount ?? 0}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20.sp,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.delete<SocialInfoController>();
                                      Get.delete<
                                          SocialInfoFollowingController>();
                                      Get.delete<
                                          SocialInfoFollowersController>();
                                      Get.delete<SocialInfoClubsController>();
                                      Get.toNamed(
                                        AppRoutes.profileSocialInfo,
                                        arguments: {
                                          'name': controller.user.value?.name,
                                          'id': controller.user.value?.id,
                                          'page': 2,
                                        },
                                        preventDuplicates: false,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Clubs',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                              ),
                                        ),
                                        ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFA2FF00),
                                              Color(0xFF00FF7F),
                                            ],
                                          ).createShader(
                                            Rect.fromLTWH(0, 0, bounds.width,
                                                bounds.height),
                                          ),
                                          child: Text(
                                            '${controller.user.value?.clubsCount ?? 0}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20.sp,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Badges',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.badges),
                      child: Row(
                        children: [
                          Obx(
                            () => ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFA2FF00),
                                  Color(0xFF00FF7F),
                                ],
                              ).createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              ),
                              child: Text(
                                '${controller.user.value?.badgesCount ?? 0}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFA2FF00),
                                Color(0xFF00FF7F),
                              ],
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              size: 25.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: (controller.user.value?.badges ?? [])
                      .map(
                        (e) => Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 12),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xFF2E2E2E),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: e.badgeIconUrl ?? '',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const ShimmerLoadingCircle(size: 50),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      radius: 32,
                                      backgroundImage: AssetImage(
                                          'assets/images/empty_profile.png'),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  e.badgeName ?? '-',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(1.w), // Lebar border
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  height: 39.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFA2FF00),
                              Color(0xFF00FF7F),
                            ],
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/overall_mileage.svg',
                            color: Colors.white,
                            height: 16.h,
                            width: 46.w,
                          ),
                        ),
                        SizedBox(width: 8.w),
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
                            'Overall Mileage',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                ),
                          ),
                        ),
                      ]),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFA2FF00),
                            Color(0xFF00FF7F),
                          ],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Text(
                          '${controller.user.value?.overallMileage ?? 0} km',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Activity',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Color(0xFFA5A5A5),
                        ),
                  ),
                  const SizedBox(height: 8),
                  // const CardActivity(),
                  // const SizedBox(height: 8),
                  // Center(
                  //   child: TextButton(
                  //     onPressed: () => Get.toNamed(AppRoutes.activity),
                  //     child: Text(
                  //       'See All',
                  //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  //             color: Theme.of(context).colorScheme.primary,
                  //             decoration: TextDecoration.underline,
                  //             decorationColor:
                  //                 Theme.of(context).colorScheme.primary,
                  //           ),
                  //     ),
                  //   ),
                  // ),
                  Obx(() {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == controller.posts.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final postActivity = controller.posts[index];
                        return ActivityCard(
                          postData: postActivity,
                          // TODO
                          // onTap: () => Get.toNamed(
                          //   AppRoutes.postDetail,
                          //   arguments: postActivity,
                          // ),
                          onTap: () {
                            Get.snackbar('Under development',
                                'This feature is under development');
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 0,
                      ),
                      itemCount: controller.posts.length +
                          (controller.hasReacheMaxPostActivity.value ? 0 : 1),
                    );
                  }),
                  // TODO: Show button show all
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
