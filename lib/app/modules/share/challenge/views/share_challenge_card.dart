import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/enums/challenge_enum.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';

class ShareChallengeCard extends StatelessWidget {
  const ShareChallengeCard({super.key, required this.challengeModel});

  final ChallengeModel challengeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: darkColorScheme.primary, width: 1),
        borderRadius: BorderRadius.circular(18.r),
        color: darkColorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/background_share.svg',
                fit: BoxFit.cover,
              ),
            ),
            
            // Lapisan Konten di atas background
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 82.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/images/zest_green.svg',
                        height: 25.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 42.h),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E5E5E),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          challengeModel.type == ChallengeTypeEnum.individual.value ? 'assets/icons/ic_individual.svg' : 'assets/icons/ic_team.svg',
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          ChallengeTypeEnum.fromValue(challengeModel.type ?? 0).challengeType,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: const Color(0xFFDCDCDC),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text(
                      challengeModel.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white, // Teks harus putih agar shader terlihat
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),

                  Text(
                    (challengeModel.mode == 0)
                    ? 'FIRST TO FINISH CHALLENGE'
                    : 'TIMED CHALLENGE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: const Color(0xFFB6B6B6),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  (challengeModel.mode == 0)
                  ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPlaceholder(
                        context: context,
                        title: 'Start Date',
                        svgIconPath: 'assets/icons/uil_calendar.svg',
                        text: (challengeModel.startDate ?? DateTime.now()).todMMMyyyyString(),
                      ),
                      _buildPlaceholder(
                        context: context,
                        title: 'Target',
                        svgIconPath: 'assets/icons/mingcute_target-line.svg',
                        text: NumberHelper().formatNumberToKWithComma(challengeModel.target),
                      ),
                    ],
                  )
                  :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPlaceholder(
                        context: context,
                        title: 'Start Date',
                        svgIconPath: 'assets/icons/uil_calendar.svg',
                        text: (challengeModel.startDate ?? DateTime.now()).todMMMyyyyString(),
                      ),
                      _buildPlaceholder(
                        context: context,
                        title: 'End Date',
                        svgIconPath: 'assets/icons/uil_calendar.svg',
                        text: (challengeModel.endDate ?? DateTime.now()).todMMMyyyyString(),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  SizedBox(
                    height: 165.h,
                    child: SvgPicture.asset(
                      'assets/icons/ic_challenge_static.svg',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),

            // Container "Powered by" di bagian bawah
            const ShareFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({
    required BuildContext context, 
    required String title,
    required String svgIconPath, 
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFB6B6B6), // Teks harus putih agar shader terlihat
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            SvgPicture.asset(
              svgIconPath,
              height: 20.h,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFDCDCDC), // Teks harus putih agar shader terlihat
              ),
            ),
          ],
        )
      ],
    );
  }
}