import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/controllers/profile_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/controllers/social_info_following.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialInfoFollowingView extends GetView<SocialInfoFollowingController> {
  const SocialInfoFollowingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Visibility(
            visible: controller.total.value > 0,
            child: TextFormField(
              controller: controller.searchController,
              onChanged: (value) => controller.onSearchChanged(value),
              decoration: InputDecoration(
                hintText: 'Search',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                fillColor: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Following',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Text(
                '(${controller.friends.length})',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.resultSearchEmpty.value) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'No result for “${controller.search.value}”',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          }
          if (controller.isLoading.value && controller.pageFriend == 1) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: const CircularProgressIndicator(),
              ),
            );
          }
          if (controller.total.value == 0) {
            return Text(
              'You Have No Following',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: controller.friends.length +
                (controller.hasReacheMax.value ? 0 : 1),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(),
            itemBuilder: (context, index) {
              if (index == controller.friends.length) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              final user = controller.friends[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFollowingListItem(context, user),
                  SizedBox(height: 15.h),
                ],
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildFollowingListItem(BuildContext context, UserMiniModel user) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        Get.delete<ProfileController>();
        Get.toNamed(AppRoutes.profileUser, arguments: user.id);
      },
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: user.imageUrl ?? '',
          width: 37.r,
          height: 37.r,
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerLoadingCircle(
            size: 37.r,
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 32.r,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            child: Text(
              user.name.toInitials(),
            ),
          ),
        ),
      ),
      title: Text(
        user.name,
        style:
            Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => InkWell(
              onTap: () {
                if (user.isFollowing == 0) {
                  controller.follow(user.id);
                }
              },
              child: Visibility(
                visible: user.id == controller.userId.value,
                replacement: Visibility(
                  visible: user.isFollowing == 0,
                  replacement: InkWell(
                    onTap: () => Get.toNamed(
                      AppRoutes.userChat,
                      arguments: user,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/msg.svg',
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/follback.svg',
                  ),
                ),
                child: CustomCircularProgressIndicator(),
              ),
            ),
          ),
          Visibility(
            visible: user.isFollowing == 1,
            child: Row(
              children: [
                SizedBox(width: 16.w),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    // Handle the selection
                    if (value == 'un_follow') {
                      controller.unFollow(user.id);
                    }
                  },
                  surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'un_follow',
                        child: Obx(
                          () => Visibility(
                            visible: controller.isLoadingFollow.value,
                            replacement: Text(
                              'Unfollow',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            child: CustomCircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ];
                  },
                  child: Icon(
                    Icons.more_vert,
                    size: 22.r,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
