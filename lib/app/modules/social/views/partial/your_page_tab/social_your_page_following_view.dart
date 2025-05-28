import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/follow_extension.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_chip.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_following_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialYourPageFollowingView extends GetView<SocialFollowingController> {
  const SocialYourPageFollowingView({super.key});

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
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        Obx(() {
          if (controller.resultSearchEmpty.value) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                margin: const EdgeInsets.symmetric(vertical: 10),
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
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              final user = controller.friends[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFollowingListItem(context, user),
                  const SizedBox(height: 15),
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
      onTap: () => Get.toNamed(AppRoutes.profileUser, arguments: user.id),
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: user.imageUrl ?? '',
          width: 37,
          height: 37,
          fit: BoxFit.cover,
          placeholder: (context, url) => const ShimmerLoadingCircle(size: 37),
          errorWidget: (context, url, error) => const CircleAvatar(
            radius: 37,
            backgroundImage: AssetImage('assets/images/empty_profile.png'),
          ),
        ),
      ),
      title: Text(
        user.name,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => CustomChip(
              onTap: () {
                if (user.isFollowing == 0) {
                  controller.follow(user.id);
                }
              },
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Visibility(
                visible: user.id == controller.userId.value,
                replacement: Text(
                  {
                    'is_follower': user.isFollowing,
                  }.followingStatus,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          Visibility(
            visible: user.isFollowing == 1,
            child: Row(
              children: [
                const SizedBox(width: 16),
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
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  child: Icon(
                    Icons.more_horiz_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
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
