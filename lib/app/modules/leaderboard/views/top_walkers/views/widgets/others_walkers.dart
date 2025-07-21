import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class OthersWalkers extends StatelessWidget {
  final bool isCurrentUser;
  final LeaderboardUserModel? walker;
  final bool isFloating;

  const OthersWalkers({super.key, required this.walker, this.isCurrentUser = false, this.isFloating = false,});

  @override
  Widget build(BuildContext context) {
    // Gunakan Material agar shadow terlihat jika isFloating true
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 10.h,
          top: 10.h,
          left: 12.w,
          right: 12.w,
        ),
        // Tambahkan shadow jika ini adalah kartu yang mengambang
        decoration: (isCurrentUser
                ? BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00FF7F), Color(0xFFA2FF00)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(11.r),
                  )
                : const BoxDecoration()),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 28.w,
                maxWidth: 28.w,
              ),
              child: Text(
                NumberHelper().formatRank(walker?.rank),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isCurrentUser ? const Color(0xFF2E2E2E) : const Color(0xFFA5A5A5),
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: walker?.imageUrl ?? '',
                width: 27.r,
                height: 27.r,
                fit: BoxFit.cover,
                placeholder: (context, url) => ShimmerLoadingCircle(size: 27.w),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 27.r,
                  backgroundImage: const AssetImage('assets/images/empty_profile.png'),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 150.w,
                maxWidth: 150.w,
              ),
              child: Text(
                '${isCurrentUser ? 'You' : walker?.name}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isCurrentUser ? const Color(0xFF2E2E2E) : const Color(0xFFA5A5A5),
                  fontSize: 12.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Text(
              NumberFormat('#,###', 'id_ID').format(walker?.totalStep ?? 0),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.normal,
                color: isCurrentUser ? const Color(0xFF2E2E2E) : darkColorScheme.primary,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}