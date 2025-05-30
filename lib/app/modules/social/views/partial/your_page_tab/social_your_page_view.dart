import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_following_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_clubs_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_followers_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_following_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_updates_view.dart';

class SocialYourPageView extends GetView<SocialController> {
  SocialYourPageView({super.key});

  final postController = Get.find<PostController>();
  final followingController = Get.find<SocialFollowingController>();
  final followersController = Get.find<SocialFollowingController>();
  final clubSearchController = Get.find<SocialClubSearchController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedChip.value;

      if (selected == YourPageChip.updates) {
        return RefreshIndicator(
          onRefresh: postController.refreshAllPosts,
          child: SingleChildScrollView(
            controller: postController.postScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                const SizedBox(height: 10),
                SocialYourPageUpdatesView(),
              ],
            ),
          ),
        );
      } else if (selected == YourPageChip.following) {
        return RefreshIndicator(
          onRefresh: () async {
            followingController.load(refresh: true);
          },
          child: SingleChildScrollView(
            controller: followingController.scrollFriendsController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                const SizedBox(height: 10),
                const SocialYourPageFollowingView(),
              ],
            ),
          ),
        );
      } else if (selected == YourPageChip.followers) {
        return RefreshIndicator(
          onRefresh: () async {
            followersController.load(refresh: true);
          },
          child: SingleChildScrollView(
            controller: followersController.scrollFriendsController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                const SizedBox(height: 10),
                const SocialYourPageFollowersView(),
              ],
            ),
          ),
        );
      } else if (selected == YourPageChip.clubs) {
        return RefreshIndicator(
          onRefresh: () async {
            clubSearchController.load(refresh: true);
          },
          child: SingleChildScrollView(
            controller: clubSearchController.scrollClubSearchController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipFilter(context),
                const SizedBox(height: 10),
                const SocialYourPageClubsView(),
              ],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChipFilter(context),
            const SizedBox(height: 10),
            Center(child: Text('No content for "$selected" yet')),
          ],
        ),
      );
    });
  }

  Widget _buildChipFilter(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: 8), // biar ada space kiri-kanan
        child: Row(
          children: [
            _buildFilterChip(context, 'Updates', YourPageChip.updates),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Following', YourPageChip.following),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Followers', YourPageChip.followers),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Clubs', YourPageChip.clubs),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(
      BuildContext context, String label, YourPageChip chipType) {
    return InkWell(
      onTap: () {
        controller.selectChip(chipType);
      },
      borderRadius: BorderRadius.circular(10),
      child: Chip(
        label: Text(label),
        backgroundColor: const Color(0xFF393939),
        labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: (controller.selectedChip.value == chipType)
                ? darkColorScheme.primary
                : Colors.transparent,
            width: 1,
          ),
        ),
      ),
    );
  }
}
