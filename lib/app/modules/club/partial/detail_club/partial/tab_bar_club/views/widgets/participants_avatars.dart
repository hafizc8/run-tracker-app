import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

// ignore: must_be_immutable
class ParticipantsAvatars extends StatelessWidget {
  ParticipantsAvatars({
    super.key,
    required this.imageUrls,
    this.avatarSize = 29,
    this.totalUsers = 0,
    this.overlapOffset = 23,
    this.maxVisible = 10,
  });

  final List<String> imageUrls;

  final int totalUsers;
  double avatarSize = 35;
  double overlapOffset = 23;
  int maxVisible = 10;

  @override
  Widget build(BuildContext context) {
    final displayCount =
        imageUrls.length > maxVisible ? maxVisible : imageUrls.length;

    final extraCount = totalUsers - displayCount;

    return SizedBox(
      height: avatarSize.h + 2, // 2 for padding
      width: displayCount * overlapOffset + avatarSize,
      child: Stack(
        children: [
          ...List.generate(displayCount, (index) {
            return Positioned(
              left: index * overlapOffset,
              child: Container(
                width: avatarSize.r,
                height: avatarSize.r,
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    width: avatarSize.r,
                    height: avatarSize.r,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        ShimmerLoadingCircle(size: avatarSize.r),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/empty_profile.png'),
                    ),
                  ),
                ),
              ),
            );
          }),
          if (totalUsers > displayCount) ...[
            Positioned(
              left: displayCount * overlapOffset,
              child: Container(
                width: avatarSize.r,
                height: avatarSize.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(
                    '+${extraCount > 999 ? '999' : extraCount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
