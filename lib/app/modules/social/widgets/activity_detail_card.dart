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
class ActivityDetailCard extends StatelessWidget {
  ActivityDetailCard({super.key, required this.postData});

  final controller = Get.find<PostController>();
  PostModel? postData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            context: context,
            userName: postData?.user?.name ?? '',
            userImageUrl: postData?.user?.imageUrl ?? '',
            createdAt: postData?.createdAt?.toHumanPostDate() ?? '',
            district: postData?.district ?? '',
          ),
          const SizedBox(height: 8),
          _buildCardContent(
            context: context,
            title: postData?.title ?? '',
            content: postData?.content ?? '',
          ),
          const SizedBox(height: 15),
          // _buildMapPlaceholder(),
          postData!.galleries.isNotEmpty ? PostMediaScroll(mediaUrls: (postData?.galleries ?? []).map((e) => e.url ?? '').toList()) : const SizedBox(),
          const SizedBox(height: 10),
          // _buildStatisticsSection(context),
          const SizedBox(height: 15),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.yellow.shade100,
          //   ),
          //   padding: const EdgeInsets.all(15),
          //   child: Row(
          //     children: [
          //       Icon(Icons.monetization_on_outlined, color: Colors.yellow.shade900),
          //       const SizedBox(width: 8),
          //       Text('Earned', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          //       const Spacer(),
          //       Text('Rp 0', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 15),
          Text(
            '${postData?.likesCount} likes',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
          ),
          const SizedBox(height: 15),
          _buildSocialActions(postData: postData),
          const SizedBox(height: 15),
          _buildCommentSection(
            context: context,
            postId: postData?.id ?? '',
            comments: postData?.comments,
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader({
    required BuildContext context, 
    required String userName,
    required String userImageUrl,
    required String createdAt,
    required String district,
  }) {
    return Row(
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
        Column(
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
      ],
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

  Widget _buildSocialActions({
    required PostModel? postData
  }) {
    return Row(
      children: [
        Expanded(
          child: SocialActionButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Icon(
                (postData?.isLiked ?? false)
                    ? Icons.local_fire_department
                    : Icons.local_fire_department_outlined,
                key: ValueKey(postData?.isLiked),
                color: lightColorScheme.primary,
                size: 18,
              ),
            ),
            label: 'Like',
            onTap: () => controller.likePost(
              postId: postData?.id ?? '',
              isDislike: (postData?.isLiked ?? false) ? 1 : 0,
              isPostDetail: true
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SocialActionButton(
            icon: Icon(Icons.chat_bubble_outline, size: 18, color: lightColorScheme.primary), 
            label: 'Comment', 
            onTap: () {}
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SocialActionButton(
            icon: Icon(Icons.share_outlined, size: 18, color: lightColorScheme.primary), 
            label: 'Share', 
            onTap: () {}
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection({
    required BuildContext context, 
    required String postId,
    List<Comment>? comments = const []
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Theme.of(context).colorScheme.onTertiary, thickness: 0.3),
        const SizedBox(height: 15),
        Text(
          'Comments',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        (comments ?? []).isNotEmpty
        ?
        ListView.builder(
          itemCount: comments?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildCommentItem(
              context: context,
              postId: postId,
              comment: comments?[index],
              replies: comments?[index].replies.map((e) {
                return _buildCommentItem(
                  context: context,
                  postId: postId,
                  comment: Comment(
                    id: e.id, 
                    content: e.content, 
                    createdAt: e.createdAt, 
                    user: e.user, 
                    replies: const []
                  ),
                  isCommentReply: true
                );
              }).toList(),
            );
          },
        )
        : 
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Comment',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
              const SizedBox(height: 5),
              Text(
                'Be the first to say something!',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem({
    required BuildContext context,
    required String postId,
    Comment? comment,
    bool isCommentReply = false,
    List<Widget>? replies = const [],
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: comment?.user?.imageUrl ?? '',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerLoadingCircle(size: 20),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/empty_profile.png'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name & Date
              Text(
                comment?.user?.name ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(width: 5),
              Text(
                comment?.createdAt?.toHumanPostDate() ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onTertiary
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Isi Komentar
          Padding(
            padding: const EdgeInsets.only(left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment?.content ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                isCommentReply 
                ? const SizedBox()
                : TextButton(
                  onPressed: () => controller.replyToAndFocusComment(replyTo: comment),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    'Reply',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12)
                  ),
                ),
                const SizedBox(height: 6),
                // Kalau ada balasan (nested replies)
                if (replies != null) ...replies,
              ],
            ),
          ),
        ],
      ),
    );
  }

}