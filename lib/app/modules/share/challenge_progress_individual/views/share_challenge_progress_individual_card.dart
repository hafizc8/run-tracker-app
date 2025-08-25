import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class ShareChallengeProgressIndividualCard extends StatelessWidget {
  const ShareChallengeProgressIndividualCard({super.key, required this.challengeModel, required this.list4TopWalker, required this.currentUser});

  final ChallengeDetailModel challengeModel;
  final List<LeaderboardUser> list4TopWalker;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/share_challenge_individual_background.jpg',
            fit: BoxFit.fitWidth,
          ),
        ),
        
        // Lapisan Konten di atas background
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/logo_zest_hitam.svg',
                    height: 25.h,
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              Text(
                challengeModel.title ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF272727),
                ),
              ),
              Text(
                (challengeModel.mode == 0)
                ? 'Target ${NumberHelper().formatNumberToKWithComma(challengeModel.target)} Steps'
                : '${(challengeModel.startDate ?? DateTime.now()).todMMMyyyyString()} - ${(challengeModel.endDate ?? DateTime.now()).todMMMyyyyString()}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF272727),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                )
              ),

              SizedBox(height: 18.h),
              Container(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 80.h),
                      width: 300.w,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/share_challenge_progess_podium.png',
                        ),
                      ),
                    ),
                    // Top 1
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: challengeModel.leaderboardUsers.isNotEmpty
                        ? _buildTop3Placeholder(context: context, leaderboardUser: challengeModel.leaderboardUsers[0])
                        : const SizedBox.shrink(),
                    ),
                    // Top 2
                    Positioned(
                      top: 50.h,
                      left: 8.w,
                      child: challengeModel.leaderboardUsers.length > 1
                        ? _buildTop3Placeholder(context: context, leaderboardUser: challengeModel.leaderboardUsers[1])
                        : const SizedBox.shrink(),
                    ),
                    // Top 3
                    Positioned(
                      top: 50.h,
                      right: 8.w,
                      child: challengeModel.leaderboardUsers.length > 2
                        ? _buildTop3Placeholder(context: context, leaderboardUser: challengeModel.leaderboardUsers[2])
                        : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 18.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white.withOpacity(0.6),
                ),
                height: 220.h,
                child: ListView(
                  children: list4TopWalker
                      .map((user) {
                        return _buildListTopWalker(
                          context: context,
                          leaderboardUser: user,
                          isCurrentUser: user.user?.id == currentUser.id,
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
        const ShareFooter(withShadow: true),
      ],
    );
  }

  Widget _buildTop3Placeholder({required BuildContext context, required LeaderboardUser leaderboardUser}) {
    return Container(
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: leaderboardUser.user?.imageUrl ?? '',
              width: 35.r,
              height: 35.r,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingCircle(size: 35.r),
              errorWidget: (context, url, error) => Container(
                width: 35.r,
                height: 35.r,
                child: CircleAvatar(
                  radius: 35.r,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .onBackground,
                  child: Text(
                    (leaderboardUser.user?.name ?? '').toInitials(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .background,
                        ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            leaderboardUser.user?.name ?? '',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF272727),
            ),
          ),
          Text(
            '${NumberHelper().formatNumberToKWithComma(leaderboardUser.point ?? 0)} Steps',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF272727),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildListTopWalker({
    required BuildContext context,
    required LeaderboardUser leaderboardUser,
    bool isCurrentUser = false
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 27.w,
              maxWidth: 27.w,
            ),
            child: Text(
              NumberHelper().formatRank(leaderboardUser.rank ?? 0),
              style: GoogleFonts.poppins(
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                color: const Color(0xFF272727),
                fontSize: 11.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: leaderboardUser.user?.imageUrl ?? '',
              width: 27.r,
              height: 27.r,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoadingCircle(size: 27.w),
              errorWidget: (context, url, error) => Container(
                width: 27.r,
                height: 27.r,
                child: CircleAvatar(
                  radius: 27.r,
                  backgroundImage: const AssetImage('assets/images/empty_profile.png'),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 110.w,
              maxWidth: 110.w,
            ),
            child: Text(
              leaderboardUser.user?.name ?? '',
              style: GoogleFonts.poppins(
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                color: const Color(0xFF272727),
                fontSize: 11.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Text(
            '${NumberFormat('#,###', 'id_ID').format(leaderboardUser.point)} Steps',
            style: GoogleFonts.poppins(
              fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF272727),
              fontSize: 11.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}