import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/challenge_team_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../../main_profile/partials/profile/controllers/profile_controller.dart';

// ignore: must_be_immutable
class ParticipantsAvatarsChallenge extends StatelessWidget {
  ParticipantsAvatarsChallenge({
    super.key,
    required this.imageUrls,
    this.challengeUsers,
    this.avatarSize = 29,
    this.totalUsers = 0,
    this.overlapOffset = 23,
    this.maxVisible = 10,
  });

  final List<String> imageUrls;
  final List<ChallengeTeamsModel>? challengeUsers; // <====>

  final int totalUsers;
  double avatarSize = 35;
  double overlapOffset = 23;
  int maxVisible = 10;

  @override
  Widget build(BuildContext context) {
    final displayCount1 =
        imageUrls.length > maxVisible ? maxVisible : imageUrls.length;
    final displayCount = (challengeUsers?.length ?? 0) > maxVisible
        ? maxVisible
        : (challengeUsers?.length ?? 0);

    final extraCount = totalUsers - displayCount;

    return SizedBox(
      height: avatarSize.h + 2, // 2 for padding
      width: displayCount * overlapOffset + avatarSize,
      child: Stack(
        children: [
          ...List.generate(displayCount, (index) {
            return Positioned(
              left: index * overlapOffset,
              child: GestureDetector(
                onTap: () {
                  if (sl<AuthService>().user?.id ==
                      challengeUsers?[index].user?.id) {
                    return;
                  }
                  Get.delete<ProfileController>();
                  Get.toNamed(AppRoutes.profileUser,
                      arguments: challengeUsers?[index].user?.id);
                },
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
                      imageUrl: challengeUsers?[index].user?.imageUrl ?? '',
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
