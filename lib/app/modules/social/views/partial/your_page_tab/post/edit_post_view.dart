import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/update_post_form.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/media_preview_edit.dart';

class EditPostView extends GetView<PostController> {
  const EditPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Edit Post'),
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () {
            if (controller.isLoadingLoadUpdatePost.value) {
              return const ShimmerLoadingList(
                itemCount: 10,
                itemHeight: 50,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              );
            }

            UpdatePostFormModel form = controller.updatePostForm.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  cursorColor: Colors.black,
                  initialValue: form.title,
                  onChanged: (value) {
                    controller.updatePostForm.value = form.copyWith(
                      title: value,
                      field: 'title',
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter title',
                    errorText: form.errors?['title'],
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  cursorColor: Colors.black,
                  initialValue: form.content,
                  onChanged: (value) {
                    controller.updatePostForm.value = form.copyWith(
                      content: value,
                      field: 'content',
                    );
                  },
                  maxLines: 3,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter content',
                    errorText: form.errors?['content'],
                  ),
                ),

                const SizedBox(height: 12),

                (form.currentGalleries ?? []).isNotEmpty 
                ? MediaPreviewEdit(
                  currentGalleries: form.currentGalleries ?? [],
                  newGalleries: form.newGalleries ?? [],
                  onRemove: (int index, bool isFromServer, Gallery? gallery, File? file) {
                    controller.removeMedia(
                      isFromServer: isFromServer,
                      gallery: gallery,
                      file: file,
                    );
                  },
                )
                : const SizedBox(),

                const SizedBox(height: 12),

                InkWell(
                  onTap: () {
                    controller.pickMultipleMediaToUpdate();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.upload_outlined,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Upload Image',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 55,
          child: Obx(
            () {
              if (controller.isLoadingLoadUpdatePost.value) {
                const SizedBox();
              }
          
              return GradientElevatedButton(
                onPressed: !controller.isValidToUpdate
                    ? null
                    : controller.isLoadingUpdatePost.value
                        ? null
                        : () {
                            controller.updatePost();
                          },
                child: Visibility(
                  visible: controller.isLoadingUpdatePost.value,
                  replacement: const Text('Continue'),
                  child: const CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}