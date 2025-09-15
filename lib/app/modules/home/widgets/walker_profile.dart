import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../../main_profile/partials/profile/controllers/profile_controller.dart';

class WalkerProfile extends StatelessWidget {
  final String rank;
  final String userId;
  final String imageUrl;
  final String name;
  final Color? backgroundColor;

  const WalkerProfile({
    super.key,
    required this.rank,
    required this.userId,
    required this.imageUrl,
    required this.name,
    this.backgroundColor,
  });

  Widget _buildRankWidget(BuildContext context, String rankString) {
    String numberPart = '';
    String suffixPart = '';

    // Memisahkan angka dari sufiks (st, nd, rd, th)
    final match = RegExp(r'(\d+)(st|nd|rd|th)?').firstMatch(rankString);
    if (match != null) {
      numberPart = match.group(1) ?? rankString;
      suffixPart = match.group(2) ?? '';
    } else {
      numberPart = rankString;
    }

    final baseStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 17.sp,
          height: 1.0, // Mengatur line-height agar lebih pas
        );

    final suffixStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 10.sp, // Ukuran font lebih kecil untuk sufiks
          height: 1.0,
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
      children: [
        Text(numberPart, style: baseStyle),
        // Beri sedikit padding agar tidak terlalu menempel
        if (suffixPart.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 1.w),
            child: Text(suffixPart, style: suffixStyle),
          ),
      ],
    );
  }

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
      child: GestureDetector(
        onTap: () {
          if (sl<AuthService>().user?.id == userId) return;
          Get.delete<ProfileController>();
          Get.toNamed(AppRoutes.profileUser, arguments: userId);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRankWidget(context, rank),
            SizedBox(height: 8.h),
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 44.r,
                height: 44.r,
                fit: BoxFit.cover,
                placeholder: (context, url) => ShimmerLoadingCircle(size: 44.w),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 44.r,
                  backgroundImage:
                      const AssetImage('assets/images/empty_profile.png'),
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
      ),
    );
  }
}
