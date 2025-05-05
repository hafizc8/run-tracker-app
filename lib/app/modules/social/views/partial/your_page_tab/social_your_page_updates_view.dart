import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/create_post_dialog.dart';
import 'package:zest_mobile/app/modules/social/widgets/activity_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialYourPageUpdatesView extends GetView<SocialController> {
  const SocialYourPageUpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActivityPrompt(context),
        const SizedBox(height: 10),
        ActivityCard(mode: PostCardMode.mapsWithStats, onTap: () => Get.toNamed(AppRoutes.socialYourPageActivityDetail)),
        const SizedBox(height: 10),
        ActivityCard(mode: PostCardMode.normal, onTap: () => Get.toNamed(AppRoutes.socialYourPageActivityDetail)),
      ],
    );
  }

  Widget _buildActivityPrompt(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(const CreatePostDialog());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: lightColorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, color: lightColorScheme.onPrimary),
            const SizedBox(width: 8),
            Text(
              'Doing some sports today? Share it!',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}