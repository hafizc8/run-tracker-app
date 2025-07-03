import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_event.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/activity_detail_card.dart';

class SocialYourPageActivityDetailView extends GetView<PostController> {
  const SocialYourPageActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoadingPostDetail.value) {
          return Padding(
            padding: EdgeInsets.all(16.0.w),
            child: const EventShimmer(),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ActivityDetailCard(
                    postData: controller.postDetail.value,
                  ),
                ),
              ),

              // Fixed TextField di bawah
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ⬇ Tampilkan ini saat membalas komentar
                    if (controller.focusedComment.value != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 9,
                              child: Text(
                                'Reply @${controller.focusedComment.value?.user?.name}: ${controller.focusedComment.value?.content}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.deleteReplyToComment(),
                              child: Icon(Icons.close, size: 20.r),
                            )
                          ],
                        ),
                      ),

                    // ⬇ TextField untuk input komentar
                    Row(
                      children: [
                        Expanded(
                          child: GradientBorderTextField(
                            focusNode: controller.commentFocusNode,
                            controller: controller.commentTextController,
                            hintText: 'Enter your comment',
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(10.0.w),
                              child: InkWell(
                                onTap: () => controller.commentPost(),
                                child: SvgPicture.asset(
                                  'assets/icons/ic_send.svg',
                                ),
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
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () => Get.back(),
      ),
      title: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Text(
          'Post Details',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle the selection
            if (value == 'edit') {
              controller.goToEditPost(
                  postId: controller.postDetail.value?.id ?? '',
                  isFromDetail: true);
            } else if (value == 'delete') {
              controller.confirmAndDeletePost(
                  postId: controller.postDetail.value?.id ?? '',
                  isPostDetail: true);
            }
          },
          icon: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Icon(
              Icons.more_horiz,
              size: 30.r,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'edit',
                child: Text(
                  'Edit Post',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete Post',
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
