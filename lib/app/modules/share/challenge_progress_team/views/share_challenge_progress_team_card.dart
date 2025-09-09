import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_team_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/modules/share/challenge_progress_team/views/team_challenge_card.dart';

class ShareChallengeProgressTeamCard extends StatelessWidget {
  const ShareChallengeProgressTeamCard({super.key, required this.challengeModel, required this.team, this.showBackground = true});

  final ChallengeDetailModel challengeModel;
  final Map<String, List<ChallengeTeamsModel>> team;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        showBackground ?
        Positioned.fill(
          child: Image.asset(
            'assets/images/share_challenge_team_background.png',
            fit: BoxFit.fitWidth,
          ),
        )
        : Container(),
        
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
                : '${(challengeModel.startDate?.toLocal() ?? DateTime.now()).todMMMyyyyString()} - ${(challengeModel.endDate?.toLocal() ?? DateTime.now()).todMMMyyyyString()}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF272727),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                )
              ),

              SizedBox(height: 18.h),

              ...challengeModel.leaderboardTeams.map((e) {
                return TeamChallengeCard(
                  rank: e.rank ?? 0,
                  teamName: e.team ?? '',
                  totalSteps: e.point ?? 0,
                  memberImageUrls: // find all user image url in team
                    team[e.team]?.map((team) => team.user?.imageUrl ?? '').toList() ?? [],
                  // teamColor: _getColorFromTeamName(e.team ?? ''),
                );
              }),
            ],
          ),
        ),
        const ShareFooter(withShadow: true),
      ],
    );
  }
}