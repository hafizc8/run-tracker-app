import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/activity_detail_card.dart';

class SocialYourPageActivityDetailView extends GetView<PostController> {
  const SocialYourPageActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(
        () {
          if (controller.isLoadingPostDetail.value) {
            return const ShimmerLoadingList(
              itemCount: 10,
              itemHeight: 50,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: ActivityDetailCard(
                      postData: controller.postDetail.value,
                    ),
                  ),
                ),

                // Fixed TextField di bawah
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ⬇ Tampilkan ini saat membalas komentar
                      if (controller.focusedComment.value != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 9,
                                child: Text(
                                  'Reply @${controller.focusedComment.value?.user?.name}: ${controller.focusedComment.value?.content}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600, 
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.deleteReplyToComment(),
                                child: const Icon(Icons.close, size: 20),
                              )
                            ],
                          ),
                        ),

                      // ⬇ TextField untuk input komentar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: controller.commentFocusNode,
                              controller: controller.commentTextController,
                              decoration: InputDecoration(
                                hintText: 'Enter your comment',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => controller.commentPost(),
                                ),
                              ),
                              onSubmitted: (value) => controller.commentPost(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.primary,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Activity Details',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle the selection
            if (value == 'edit') {
              controller.goToEditPost(postId: controller.postDetail.value?.id ?? '', isFromDetail: true);
            } else if (value == 'delete') {
              controller.confirmAndDeletePost(postId: controller.postDetail.value?.id ?? '', isPostDetail: true);
            }
          },
          icon: Icon(
            Icons.more_horiz,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'edit',
                child: Text(
                  'Edit Activity',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete Activity',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}
