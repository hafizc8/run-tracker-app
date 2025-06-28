// Letakkan widget ini di file yang sama atau file terpisah
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
    // Menggunakan ColorScheme dari tema saat ini
    final darkColorScheme = Theme.of(context).colorScheme;

    return Container(
      // Dekorasi hanya diterapkan jika backgroundColor tidak null
      decoration: backgroundColor != null
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            )
          : null,
      padding: EdgeInsets.symmetric(
        vertical: 16.h, 
        horizontal: backgroundColor != null ? 16.w : 15.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar Column tidak memakan ruang berlebih
        children: [
          Text(
            rank,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: darkColorScheme.primary,
                  fontSize: 17.sp,
                ),
          ),
          const SizedBox(height: 8),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 44.w,
              height: 44.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingCircle(size: 44.w),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 22.r, // Setengah dari width/height
                backgroundImage: const AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: darkColorScheme.primary,
                  fontSize: 12.sp,
                ),
          ),
        ],
      ),
    );
  }
}