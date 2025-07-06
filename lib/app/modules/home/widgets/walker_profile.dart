import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class WalkerProfile extends StatelessWidget {
  final String rank;
  final String imageUrl;
  final String name;
  final Color? backgroundColor;

  const WalkerProfile({
    super.key,
    required this.rank,
    required this.imageUrl,
    required this.name,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final darkColorScheme = Theme.of(context).colorScheme;

    // ✨ 1. Hapus SizedBox dengan lebar tetap.
    // Lebar sekarang akan dikontrol oleh widget Expanded di parent-nya.
    return Container(
      decoration: backgroundColor != null
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            )
          : null,
      padding: EdgeInsets.symmetric(
        vertical: 16.h, 
        horizontal: 8.w, // Beri sedikit padding horizontal
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rank,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: darkColorScheme.primary,
                  fontSize: 17.sp,
                ),
          ),
          SizedBox(height: 8.h),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 44.r,
              height: 44.r,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingCircle(size: 44.w),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 22.r,
                backgroundImage: const AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          
          // ✨ 2. Bungkus Text dengan Flexible agar tidak menyebabkan overflow di dalam Column
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: darkColorScheme.primary,
                    fontSize: 12.sp,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
