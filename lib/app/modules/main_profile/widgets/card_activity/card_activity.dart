import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:zest_mobile/app/modules/main_profile/controllers/main_profile_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/post_media.dart';
import 'package:zest_mobile/app/modules/social/widgets/social_action_button.dart';
import 'package:zest_mobile/app/modules/social/widgets/statistic_column.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

// ignore: must_be_immutable
class ActivityCard extends StatelessWidget {
  ActivityCard({
    super.key,
    this.onTap,
    required this.postData,
  });

  void Function()? onTap;
  PostModel postData;
  final PostController postController = Get.find();
  final ProfileMainController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.h,
        ),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(
                context: context,
                userId: postData.user?.id ?? '',
                userName: postData.user?.name ?? '',
                userImageUrl: postData.user?.imageUrl ?? '',
                createdAt: postData.createdAt?.toHumanPostDate() ?? '',
                district: postData.district ?? '',
                isOwner: postData.isOwner ?? false),
            SizedBox(height: 8.h),
            _buildCardContent(
              context: context,
              title: postData.title ?? '',
              content: postData.content ?? '',
            ),
            SizedBox(height: 15.h),

            // Media Horizontal (Maps, Image, Video)
            Builder(builder: (context) {
              // 1. Siapkan list kosong untuk menampung semua media
              final List<Widget> allMediaItems = [];

              // 2. Tambahkan widget peta sebagai item pertama jika ada data
              if (postData.recordActivity != null) {
                allMediaItems.add(
                  Visibility(
                    visible: postData.galleries.isEmpty,
                    // when galleries is not empty
                    replacement: _buildMapPlaceholder(postData.galleryMap),
                    // when galleries is empty
                    child: Stack(
                      children: [
                        _buildMapPlaceholder(postData.galleryMap),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _buildStatisticsSection(
                              context: context,
                              recordActivity: postData.recordActivity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // 3. Tambahkan gambar dan video dari galeri
              for (var galleryItem in postData.galleries) {
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
                            child: const Center(
                                child: CircularProgressIndicator()),
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
              visible: postData.recordActivity != null &&
                  postData.galleries.isNotEmpty,
              child: Container(
                margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: _buildStatisticsSection(
                    context: context,
                    recordActivity: postData.recordActivity,
                  ),
                ),
              ),
            ),

            Visibility(
              visible: (postData.likesCount ?? 0) > 0,
              child: Container(
                margin: EdgeInsets.only(top: 10.h),
                child: Row(
                  children: [
                    ParticipantsAvatars(
                      avatarSize: 20,
                      maxVisible: 3,
                      overlapOffset: 16,
                      imageUrls: postData.likes
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
                          TextSpan(text: postData.likesCount.toString()),
                          TextSpan(
                            text: ' Likes',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
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
            SizedBox(height: 15.h),
            _buildSocialActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(
      {required BuildContext context,
      required String userId,
      required String userName,
      required String userImageUrl,
      required String createdAt,
      required String district,
      required bool isOwner}) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.profileUser, arguments: userId),
      child: SizedBox(
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
                SizedBox(width: 8.w),
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        district,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF6C6C6C),
                              fontSize: 11.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // PopupMenuButton di kanan
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(
                  visible: isOwner,
                  child: InkWell(
                    onTapDown: (details) async {
                      await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          0,
                          0,
                        ),
                        surfaceTintColor:
                            Theme.of(context).colorScheme.onPrimary,
                        items: [
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
                        ],
                        elevation: 8.0,
                      ).then((value) {
                        if (value == 'edit') {
                          postController.goToEditPost(postId: postData.id ?? '', isFromDetail: false);
                        } else if (value == 'delete') {
                          profileController.confirmAndDeletePost(postId: postData.id ?? '');
                        }
                      });
                    },
                    child: Icon(
                      Icons.more_horiz,
                      size: 35.r,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                Text(
                  createdAt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6C6C6C),
                        fontSize: 11.sp,
                      ),
                ),
              ],
            ),
          ],
        ),
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
    // return StaticRouteMap(
    //   activityLogs: recordActivity?.recordActivityLogs ?? [],
    //   height: 310.h,
    // );

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
            value: postController.unitHelper.formatDistance(
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

  Widget _buildSocialActions() {
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
                  color: postData.isLiked!
                      ? darkColorScheme.primary
                      : darkColorScheme.onBackground,
                  key: ValueKey(postData.isLiked),
                ),
              ),
              label: 'Like',
              onTap: () {
                profileController.likePost(
                  postId: postData.id!,
                  isDislike: postData.isLiked! ? 1 : 0,
                );
              },
              selected: postData.isLiked!,
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
              onTap: () {
                profileController.goToDetailPost(post: postData, isFocusComment: true);
              },
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
                if ((postData.isOwner ?? false) && postData.recordActivity != null) {
                  Get.toNamed(AppRoutes.shareActivity, arguments: postData);
                } else {
                  Share.share(
                    AppConstants.sharePostLink(postData.id!),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
