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
        Obx(
          () {
            if (postController.isLoadingGetAllPost.value) {
              return const ShimmerLoadingList(
                itemCount: 5,
                itemHeight: 120,
                itemSpacing: 15,
                padding: EdgeInsets.all(0),
              );
            }

            if (postController.posts.value?.data.isEmpty ?? true) {
              return SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    'No Activity',
                    style: Theme.of(context).textTheme.headlineSmall
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: postController.posts.value?.data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ActivityCard(
                  postData: postController.posts.value!.data[index], 
                  onTap: () => Get.toNamed(AppRoutes.socialYourPageActivityDetail)
                );
              }
            );
          }
        ),
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