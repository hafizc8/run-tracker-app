import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/social_action_button.dart';
import 'package:zest_mobile/app/modules/social/widgets/statistic_column.dart';

class SocialYourPageUpdatesView extends GetView<SocialController> {
  const SocialYourPageUpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActivityPrompt(context),
        const SizedBox(height: 10),
        _buildPostCard(context: context, mode: PostCardMode.mapsWithStats),
        const SizedBox(height: 10),
        _buildPostCard(context: context, mode: PostCardMode.normal),
      ],
    );
  }

  Widget _buildActivityPrompt(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildPostCard({
    required BuildContext context,
    required PostCardMode mode,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: lightColorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context),
          const SizedBox(height: 8),
          _buildCardContent(context),
          const SizedBox(height: 8),
          (mode == PostCardMode.mapsWithStats) ? _buildMapPlaceholder() : _buildImagePlaceholder(),
          (mode == PostCardMode.mapsWithStats) ? const SizedBox(height: 10) : const SizedBox(),
          (mode == PostCardMode.mapsWithStats) ? _buildStatisticsSection() : const SizedBox(),
          const SizedBox(height: 15),
          _buildSocialActions(),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16, 
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('John Doe', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            Text('Today, San Francisco, 05:00 AM', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: lightColorScheme.onTertiary)),
          ],
        ),
        const Spacer(),
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle the selection
            if (value == 'edit') {
              // Handle Edit Post action
            } else if (value == 'delete') {
              // Handle Delete Post action
            }
          },
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(context).colorScheme.primary,
          ),
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'edit',
                child: Text(
                  'Edit Post',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete Post',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Morning Walk', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18, color: lightColorScheme.onSurface)),
        Text('Freezing morning run', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: lightColorScheme.onSurface)),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Map Placeholder', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Image Placeholder', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: lightColorScheme.primary,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatisticsColumn(title: 'DISTANCE', value: '2.57 km'),
          StatisticsColumn(title: 'STEPS', value: '4,052'),
          StatisticsColumn(title: 'AVG. PACE', value: '8:10'),
          StatisticsColumn(title: 'MOVING TIME', value: '37:17'),
        ],
      ),
    );
  }

  Widget _buildSocialActions() {
    return Row(
      children: [
        SocialActionButton(icon: Icons.local_fire_department_outlined, label: 'Like', onTap: () {}),
        const SizedBox(width: 8),
        SocialActionButton(icon: Icons.chat_bubble_outline, label: 'Comment', onTap: () {}),
        const SizedBox(width: 8),
        SocialActionButton(icon: Icons.share_outlined, label: 'Share', onTap: () {}),
      ],
    );
  }
}