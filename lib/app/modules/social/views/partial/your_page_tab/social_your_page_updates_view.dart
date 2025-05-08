import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/activity_card.dart';
import 'package:zest_mobile/app/modules/social/widgets/loading_create_post.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialYourPageUpdatesView extends GetView<SocialController> {
  SocialYourPageUpdatesView({super.key});

  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            if (postController.isLoadingCreatePost.value) {
              return const LoadingCreatePost();
            }
    
            return _buildActivityPrompt(context);
          }
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (postController.isLoadingGetAllPost.value && postController.pagePost == 1) {
            return const ShimmerLoadingList(
              itemCount: 5,
              itemHeight: 120,
              itemSpacing: 15,
              padding: EdgeInsets.all(0),
            );
          }
        
          if (postController.posts.isEmpty) {
            return Center(
              child: Text(
                'No Activity',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
        
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: postController.posts.length + (postController.hasReacheMax.value ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == postController.posts.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
          
              return ActivityCard(
                postData: postController.posts[index]!,
                onTap: () => Get.toNamed(AppRoutes.socialYourPageActivityDetail),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildActivityPrompt(BuildContext context) {
    return InkWell(
      onTap: () {
        postController.openCreatePostDialog();
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