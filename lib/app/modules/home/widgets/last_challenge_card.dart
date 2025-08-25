import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class LastChallengeCard extends StatelessWidget {
  const LastChallengeCard({super.key, required this.challenge});

  final ChallengeModel? challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkColorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Challenge',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      challenge?.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFFA5A5A5),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Container(
                  // color: Colors.grey,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildParticipantAvatars(
                      challengeUsers: challenge?.challengeUsers,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.challengedetails, arguments: {
                'challengeId': challenge?.id,
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'See Challenges',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: darkColorScheme.primary,
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(
                  'assets/icons/ic_more_challenge_home_page.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantAvatars({List<ChallengeUserModel>? challengeUsers}) {
    // print(challengeUsers);
    List<String> memberImageUrls = challengeUsers?.map((e) => e.user?.imageUrl ?? '').toList() ?? [];

    // Tentukan jumlah maksimal avatar yang ingin ditampilkan
    const int maxVisibleAvatars = 3;
    final int totalMembers = memberImageUrls.length;

    // Cek apakah jumlah anggota melebihi batas maksimal
    final bool hasMoreMembers = totalMembers > maxVisibleAvatars;

    // Tentukan berapa banyak avatar yang akan di-render
    final int visibleAvatarCount = hasMoreMembers ? maxVisibleAvatars : totalMembers;

    // Buat daftar widget untuk Stack
    List<Widget> avatarWidgets = List.generate(visibleAvatarCount, (index) {
      return Positioned(
        left: (index * 22.0).w, // Geser setiap avatar ke kanan
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: memberImageUrls[index],
              width: 40.r,
              height: 40.r,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingCircle(size: 40.r),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 20.r,
                backgroundImage: const AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
        ),
      );
    });

    // Jika ada anggota lebih, tambahkan widget lingkaran "+N"
    if (hasMoreMembers) {
      final int remainingCount = totalMembers - maxVisibleAvatars;
      avatarWidgets.add(
        Positioned(
          left: (maxVisibleAvatars * 20.0).w,
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: darkColorScheme.primary.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 42.r, // Atur tinggi area tumpukan avatar
      // Lebar dihitung agar semua avatar dan lingkaran "+N" muat
      width: (visibleAvatarCount * 20.0).w + 40.r,
      child: Stack(
        children: avatarWidgets,
      ),
    );
  }
}