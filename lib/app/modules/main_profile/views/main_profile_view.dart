import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/custom_tab_bar/views/custom_tab_bar_view.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/main_profile_controller.dart';

class MainProfileView extends GetView<ProfileMainController> {
  const MainProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        ScrollController scrollController = ScrollController();
        switch (controller.tabBarController.selectedIndex.value) {
          case 1:
            scrollController = controller.postActivityController;
            break;
          case 1:
            scrollController = controller.challengeController;
            break;
          case 2:
            scrollController = controller.eventController;
            break;
          default:
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.getDetailUser();
            switch (controller.tabBarController.selectedIndex.value) {
              case 0:
                controller.getPostActivity(refresh: true);
                break;
              case 1:
                controller.getChallenges(refresh: true);
                break;
              case 2:
                controller.getEvents(refresh: true);
                break;
              default:
            }
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 16.w,
                        ),
                        height: 256.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 16.h),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              controller.user.value?.imageUrl ??
                                                  '',
                                          width: 50.r,
                                          height: 50.r,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              ShimmerLoadingCircle(
                                            size: 50.r,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                            radius: 32.r,
                                            backgroundImage: const AssetImage(
                                              'assets/images/empty_profile.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 150.r,
                                                ),
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
                                              SizedBox(width: 8.w),
                                              GestureDetector(
                                                onTap: () async {
                                                  var res = await Get.toNamed(
                                                      AppRoutes.profileEdit);
                                                  if (res != null) {
                                                    controller.user.value = res;
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
                                            ],
                                          ),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 150),
                                            child: Text(
                                              '${controller.user.value?.province ?? '-'}, ${controller.user.value?.country ?? '-'}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Text(
                                    ' ${controller.user.value?.bio ?? ''}',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  child: SvgPicture.asset(
                                    'assets/icons/share.svg',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    height: 22.h,
                                    width: 27.w,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                IconButton(
                                  icon: const Icon(Icons.settings_outlined),
                                  iconSize: 22.h,
                                  onPressed: () =>
                                      Get.toNamed(AppRoutes.settings),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 57.h,
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
                                  Column(
                                    children: [
                                      Text(
                                        'Following',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Text(
                                        '${controller.user.value?.followingCount ?? 0}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Followers',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Text(
                                        '${controller.user.value?.followersCount ?? 0}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Clubs',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      Text(
                                        '${controller.user.value?.clubsCount ?? 0}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      ),
                                    ],
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
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Badges',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Color(0xFFA5A5A5),
                          ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.badges),
                      child: Row(
                        children: [
                          Obx(
                            () => Text(
                              '${controller.user.value?.badgesCount ?? 0}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Color(0xFFA5A5A5),
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFFA5A5A5),
                            size: 22.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (controller.user.value?.badges ?? [])
                        .map(
                          (e) => Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                bottom: 12.h,
                              ),
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
                                      width: 50.r,
                                      height: 50.r,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          ShimmerLoadingCircle(size: 50.r),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 32.r,
                                        backgroundImage: const AssetImage(
                                            'assets/images/empty_profile.png'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    e.badgeName ?? '-',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SvgPicture.asset('assets/icons/overall_mileage.svg'),
                        SizedBox(width: 8.w),
                        Text(
                          'Overall Mileage',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ]),
                      Text(
                        '${controller.user.value?.overallMileage ?? 0} km',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                CustomTabBar(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
