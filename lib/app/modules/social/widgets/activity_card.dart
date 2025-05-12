import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/post_media.dart';
import 'package:zest_mobile/app/modules/social/widgets/social_action_button.dart';
import 'package:zest_mobile/app/modules/social/widgets/statistic_column.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';

// ignore: must_be_immutable
class ActivityCard extends StatelessWidget {
  ActivityCard({
    super.key, 
    this.onTap,
    required this.postData,
  });

  void Function()? onTap;
  PostModel postData;
  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background,
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
            _buildCardHeader(
              context: context,
              userName: postData.user?.name ?? '',
              userImageUrl: postData.user?.imageUrl ?? '',
              createdAt: postData.createdAt?.toHumanPostDate() ?? '',
              district: postData.district ?? '',
              isOwner: postData.isOwner ?? false
            ),
            const SizedBox(height: 8),
            _buildCardContent(
              context: context,
              title: postData.title ?? '',
              content: postData.content ?? '',
            ),
            const SizedBox(height: 15),
            postData.galleries.isNotEmpty ? PostMediaScroll(mediaUrls: postData.galleries.map((e) => e.url ?? '').toList()) : const SizedBox(),
            const SizedBox(height: 15),
            _buildSocialActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader({
    required BuildContext context, 
    required String userName,
    required String userImageUrl,
    required String createdAt,
    required String district,
    required bool isOwner
  }) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // CircleAvatar dan Column di kiri, tetap dekat
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: userImageUrl,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerLoadingCircle(size: 30),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/empty_profile.png'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Column di tengah
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$district, $createdAt',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // PopupMenuButton di kanan
          isOwner
          ?
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selection
              if (value == 'edit') {
                // Handle Edit Post action
              } else if (value == 'delete') {
                postController.confirmAndDeletePost(postId: postData.id ?? '');
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
          )
          :
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCardContent({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
      title.isEmpty ? 
      [
        Text(content, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
      ]
      :
      [
        Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 5),
        Text(content, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
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

  Widget _buildImageFromUrl() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://dev.zestplus.app/storage/posts/vfAmuTYfzlVqYwo9bvSramLd1mX8bNfYlaz2atTN.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildStatisticsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Theme.of(context).colorScheme.primary,
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
        SocialActionButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Icon(
              postData.isLiked!
                  ? Icons.local_fire_department
                  : Icons.local_fire_department_outlined,
              key: ValueKey(postData.isLiked),
              color: lightColorScheme.primary,
              size: 18,
            ),
          ),
          label: 'Like',
          onTap: () => postController.likePost(
            postId: postData.id!,
            isDislike: postData.isLiked! ? 1 : 0,
          ),
        ),

        const SizedBox(width: 8),
        SocialActionButton(
          icon: Icon(Icons.chat_bubble_outline, size: 18, color: lightColorScheme.primary), 
          label: 'Comment', 
          onTap: () {}
        ),
        const SizedBox(width: 8),
        SocialActionButton(
          icon: Icon(Icons.share_outlined, size: 18, color: lightColorScheme.primary), 
          label: 'Share', 
          onTap: () {}
        ),
      ],
    );
  }
}