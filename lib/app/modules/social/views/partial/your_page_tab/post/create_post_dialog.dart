import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zest_mobile/app/core/models/forms/create_post_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
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
        borderRadius: BorderRadius.circular(16.r),
      ),
      insetPadding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(18.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: postController.user?.imageUrl ?? '',
                    width: 35.r,
                    height: 35.r,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        ShimmerLoadingCircle(size: 35.r),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 32.r,
                      backgroundImage:
                          const AssetImage('assets/images/empty_profile.png'),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What\'s up ${postController.user?.name}?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h),
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
            SizedBox(height: 12.h),

            Obx(() {
              CreatePostFormModel form = postController.form.value;

              return Column(
                children: [
                  TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Jot down your activity here',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      errorText: form.errors?['content'],
                    ),
                    onChanged: (value) {
                      postController.form.value = form.copyWith(
                        field: 'content',
                        content: value,
                      );
                    },
                  ),

                  SizedBox(height: 12.h),

                  // Optional: Media Upload / Tags / Location
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          postController.pickMultipleMedia();
                        },
                        icon: Icon(
                          Icons.photo,
                          size: 18.r,
                        ),
                        label: Text(
                          'Add Photo',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 12.sp,
                              ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.w),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 15.w)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                ],
              );
            }),

            Obx(() {
              if ((postController.form.value.galleries ?? []).isEmpty)
                return const SizedBox();
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
                  SizedBox(height: 10.h),
                  MediaPreview(
                      medias: (postController.form.value.galleries ?? [])
                          .map((e) => XFile(e.path))
                          .toList()),
                ],
              );
            }),

            SizedBox(height: 20.h),

            // Action Button
            Row(
              children: [
                // Tombol Back (30%)
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50.h,
                    child: GradientOutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'Back',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Tombol Post (70%)
                Expanded(
                  flex: 7,
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: GradientElevatedButton(
                      onPressed: () {
                        postController.createPost(context);
                      },
                      child: Text(
                        'Post',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
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
