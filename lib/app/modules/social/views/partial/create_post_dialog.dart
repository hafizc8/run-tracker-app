import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zest_mobile/app/core/models/forms/create_post_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/media_preview.dart';

class CreatePostDialog extends GetView<SocialController> {
  CreatePostDialog({super.key});

  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: postController.user?.imageUrl ?? '',
                  width: 35,
                  placeholder: (context, url) => const ShimmerLoadingCircle(size: 25),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/empty_profile.png',
                      ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What\'s up ${postController.user?.name}?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Share a photo, post, or activity with your followers!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
        
            Obx(
              () {
                CreatePostFormModel form = postController.form.value;

                return Column(
                  children: [
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Jot down your activity here',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        errorText: form.errors?['content'],
                      ),
                      onChanged: (value) {
                        postController.form.value = form.copyWith(
                          field: 'content',
                          content: value,
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Optional: Media Upload / Tags / Location
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            postController.pickMultipleMedia();
                          }, 
                          icon: const Icon(
                            Icons.photo,
                            size: 18,
                          ), 
                          label: Text(
                            'Add Photo or Video',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 15)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                );
              }
            ),

            Obx(
              () {
                if ((postController.form.value.galleries ?? []).isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Media: ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MediaPreview(medias: (postController.form.value.galleries?? []).map((e) => XFile(e.path)).toList()),
                  ],
                );
              }
            ),

            const SizedBox(height: 20),

            // Action Button
            Row(
              children: [
                // Tombol Back (30%)
                Expanded(
                  flex: 3,
                  child: OutlinedButtonTheme(
                    data: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size.fromHeight(40),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Back'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Tombol Post (70%)
                Expanded(
                  flex: 7,
                  child: ElevatedButtonTheme(
                    data: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size.fromHeight(40),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        postController.createPost(context);
                      },
                      child: const Text('Post'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
