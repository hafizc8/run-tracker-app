import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class OthersWalkers extends StatelessWidget {
  final bool isCurrentUser;

  const OthersWalkers({super.key, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 10,
        top: 10,
        left: 18,
        right: 18,
      ),
      decoration: isCurrentUser 
      ? BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00FF7F),
            Color(0xFFA2FF00),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(11.r),
      )
      : const BoxDecoration(),
      child: Row(
        children: [
          Text(
            '4th',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isCurrentUser ? const Color(0xFF2E2E2E) : const Color(0xFFA5A5A5),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 10.w),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://avatar.iran.liara.run/public/16',
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
          Text(
            'Dominic Alaric',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.normal,
              color: isCurrentUser ? const Color(0xFF2E2E2E) : const Color(0xFFA5A5A5),
              fontSize: 12.sp,
            ),
          ),
          const Spacer(),
          Text(
            NumberFormat('#,###').format(1600000),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.normal,
              color: isCurrentUser ? const Color(0xFF2E2E2E) : darkColorScheme.primary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}