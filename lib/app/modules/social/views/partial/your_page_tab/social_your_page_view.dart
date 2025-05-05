import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_clubs_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_followers_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_following_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_updates_view.dart';

class SocialYourPageView extends GetView<SocialController> {
  const SocialYourPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final selected = controller.selectedChip.value;

        Widget content;

        if (selected == YourPageChip.updates) {
          content = const SocialYourPageUpdatesView();

        } else if (selected == YourPageChip.following) {
          content = const SocialYourPageFollowingView();

        } else if (selected == YourPageChip.followers) {
          content = const SocialYourPageFollowersView();

        } else if (selected == YourPageChip.clubs) {
          content = const SocialYourPageClubsView();

        } else {
          content = Center(child: Text('No content for "$selected" yet'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChipFilter(context),
              const SizedBox(height: 10),
              content,
            ],
          ),
        );
      }
    );
  }

  Widget _buildChipFilter(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8), // biar ada space kiri-kanan
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


  Widget _buildFilterChip(BuildContext context, String label, YourPageChip chipType) {
    return InkWell(
      onTap: () {
        controller.selectChip(chipType);
      },
      borderRadius: BorderRadius.circular(20),
      child: Chip(
        label: Text(label),
        backgroundColor: const Color(0xFFdaebfe),
        labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: (controller.selectedChip.value == chipType) ? lightColorScheme.primary : Colors.transparent,
            width: 1,
          ),
        ),
      ),
    );
  }
}