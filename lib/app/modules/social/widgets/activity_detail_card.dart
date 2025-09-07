import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/models/model/record_activity_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_rectangle.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/post_media.dart';
import 'package:zest_mobile/app/modules/social/widgets/social_action_button.dart';
import 'package:zest_mobile/app/modules/social/widgets/statistic_column.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

// ignore: must_be_immutable
class ActivityDetailCard extends StatelessWidget {
  ActivityDetailCard({super.key, required this.postData});

  final controller = Get.find<PostController>();
  PostModel? postData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            context: context,
            userId: postData?.user?.id ?? '',
            userName: postData?.user?.name ?? '',
            userImageUrl: postData?.user?.imageUrl ?? '',
            createdAt: postData?.createdAt?.toHumanPostDate() ?? '',
            district: postData?.district ?? '',
          ),
          SizedBox(height: 8.h),
          _buildCardContent(
            context: context,
            title: postData?.title ?? '',
            content: postData?.content ?? '',
          ),
          SizedBox(height: 15.h),

          // Media Horizontal (Maps, Image, Video)
          Builder(builder: (context) {
            // 1. Siapkan list kosong untuk menampung semua media
            final List<Widget> allMediaItems = [];

            // 2. Tambahkan widget peta sebagai item pertama jika ada data
            if (postData?.recordActivity != null) {
              allMediaItems.add(
                Visibility(
                  visible: (postData?.galleries ?? []).isEmpty,
                  // when galleries is not empty
                  replacement: _buildMapPlaceholder(postData?.galleryMap),
                  // when galleries is empty
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: _buildMapPlaceholder(postData?.galleryMap),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: _buildStatisticsSection(
                            context: context,
                            recordActivity: postData?.recordActivity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 3. Tambahkan gambar dan video dari galeri
            for (var galleryItem in postData?.galleries ?? []) {
              final url = galleryItem.url ?? '';
              if (url.isNotEmpty) {
                // Logika untuk membedakan video atau gambar dipindahkan ke sini
                bool isVideo = url.endsWith('.mp4') ||
                    url.endsWith('.mov') ||
                    url.endsWith('.webm');

                if (isVideo) {
                  continue;
                } else {
                  allMediaItems.add(
                    Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey.shade300,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  );
                }
              }
            }

            // 4. Panggil PostMediaScroll yang sudah dimodifikasi dengan list widget
            return PostMediaScroll(mediaItems: allMediaItems);
          }),

          // Statistic with media > 1
          Visibility(
            visible: postData?.recordActivity != null &&
                (postData?.galleries ?? []).isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(top: 16.h, bottom: 10.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: _buildStatisticsSection(
                  context: context,
                  recordActivity: postData?.recordActivity,
                ),
              ),
            ),
          ),
          Visibility(
            visible: postData?.recordActivity != null,
            child: Container(
              height: 41.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: postData?.recordActivity != null &&
                      (postData?.galleries ?? []).isNotEmpty
                  ? const EdgeInsets.only(top: 8)
                  : const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFA5A5A5)),
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFA2FF00),
                          Color(0xFF00FF7F),
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/ic_coin.svg',
                        color: Colors.white,
                        height: 16.h,
                        width: 46.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFA2FF00),
                          Color(0xFF00FF7F),
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        'Earned',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                            ),
                      ),
                    ),
                  ]),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFA2FF00),
                        Color(0xFF00FF7F),
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      postData?.recordActivity?.coin ?? '-',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: (postData?.likesCount ?? 0) > 0,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ParticipantsAvatars(
                    avatarSize: 20,
                    maxVisible: 3,
                    overlapOffset: 16,
                    imageUrls: postData?.likes
                            ?.map((e) => e.imageUrl ?? '')
                            .toList() ??
                        [],
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                      children: <TextSpan>[
                        TextSpan(text: postData?.likesCount.toString()),
                        TextSpan(
                          text: ' Likes',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 13.sp,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          _buildSocialActions(postData: postData),
          SizedBox(height: 15.h),
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
    required String userId,
    required String userName,
    required String userImageUrl,
    required String createdAt,
    required String district,
  }) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.profileUser, arguments: userId),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: userImageUrl,
              width: 30.r,
              height: 30.r,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingCircle(size: 30.r),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 30.r,
                backgroundImage:
                    const AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '$district, $createdAt',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6C6C6C),
                      fontSize: 11.sp,
                    ),
              ),
            ],
          ),
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
      children: title.isEmpty
          ? [
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ]
          : [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 5.h),
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
    );
  }

  Widget _buildMapPlaceholder(Gallery? galleryMap) {
    return CachedNetworkImage(
      imageUrl: galleryMap?.url ?? '',
      width: double.infinity,
      height: 310.h,
      fit: BoxFit.cover,
      placeholder: (context, url) => ShimmerLoadingRectangle(height: 310.h),
      errorWidget: (context, url, error) => _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 64.r, color: Colors.grey),
                SizedBox(height: 8.h),
                const Text('Maps not available', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection({
    required BuildContext context,
    required RecordActivityModel? recordActivity,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFA2FF00),
            Color(0xFF00FF7F),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatisticsColumn(
            title: 'Distance',
            value: controller.unitHelper.formatDistance(
              recordActivity?.lastRecordActivityLog?.distance ?? 0,
            ),
          ),
          StatisticsColumn(
              title: 'AVG Pace',
              value: NumberHelper().formatDuration(int.parse(
                  (recordActivity?.lastRecordActivityLog?.pace ?? 0.0)
                      .toStringAsFixed(0)))),
          StatisticsColumn(
              title: 'Moving Time',
              value: NumberHelper().formatDuration(
                  recordActivity?.lastRecordActivityLog?.time ?? 0)),
        ],
      ),
    );
  }

  Widget _buildSocialActions({required PostModel? postData}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: SocialActionButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: FaIcon(
                  FontAwesomeIcons.fire,
                  size: 15.r,
                  color: (postData?.isLiked ?? false)
                      ? darkColorScheme.primary
                      : darkColorScheme.onBackground,
                  key: ValueKey(postData?.isLiked),
                ),
              ),
              label: 'Like',
              onTap: () => controller.likePost(
                  postId: postData?.id ?? '',
                  isDislike: (postData?.isLiked ?? false) ? 1 : 0,
                  isPostDetail: true),
              selected: postData?.isLiked ?? false,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: SocialActionButton(
              icon: FaIcon(
                FontAwesomeIcons.comment,
                size: 15.r,
                color: darkColorScheme.onBackground,
              ),
              label: 'Comment',
              onTap: () => controller.focusToComment(),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: SocialActionButton(
              icon: FaIcon(
                FontAwesomeIcons.paperPlane,
                size: 15.r,
                color: darkColorScheme.onBackground,
              ),
              label: 'Share',
              onTap: () {
                final bool isOwner = controller.user?.id == postData?.user?.id;
                if (isOwner && postData?.recordActivity != null) {
                  Get.toNamed(AppRoutes.shareActivity, arguments: postData);
                } else {
                  Share.share(
                    AppConstants.sharePostLink(postData?.id ?? ''),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection(
      {required BuildContext context,
      required String postId,
      List<Comment>? comments = const []}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
            color: Theme.of(context).colorScheme.onTertiary, thickness: 0.3),
        SizedBox(height: 15.h),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFA2FF00),
              Color(0xFF00FF7F),
            ],
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'Comments',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        SizedBox(height: 15.h),
        (comments ?? []).isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF393939),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: ListView.builder(
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
                                replies: const []),
                            isCommentReply: true);
                      }).toList(),
                    );
                  },
                ),
              )
            : SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_no_comment.svg',
                      width: 74.w,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'No Comment',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Be the first to say something!',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary),
                    ),
                  ],
                ),
              ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 500,
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
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto Profil
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: comment?.user?.imageUrl ?? '',
              width: 30.r,
              height: 30.r,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  ShimmerLoadingCircle(size: 30.r),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 30.r,
                backgroundImage:
                    const AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Name & Date
                    Flexible(
                      flex: 6,
                      child: Text(
                        comment?.user?.name ?? '',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.sp,
                          color: const Color(0xFFA5A5A5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.only(left: 6.w),
                        child: Text(
                          comment?.createdAt?.toHumanPostDate() ?? '',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: const Color(0xFF6A6A6A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
            
                // Isi Komentar
                Padding(
                  padding: EdgeInsets.only(left: 0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        comment?.content ?? '',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp,
                              color: const Color(0xFFA5A5A5),
                              height: 1.8,
                            ),
                      ),
                      const SizedBox(height: 6),
                      isCommentReply
                          ? const SizedBox()
                          : Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            child: TextButton(
                                onPressed: () =>
                                    controller.replyToAndFocusComment(replyTo: comment),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerLeft,
                                ),
                                child: Text(
                                  'Reply',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontSize: 12.sp,
                                      ),
                                ),
                              ),
                          ),
                      // Kalau ada balasan (nested replies)
                      if (replies != null) ...replies,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
