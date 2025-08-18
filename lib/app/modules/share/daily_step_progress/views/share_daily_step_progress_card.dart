import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/step_tracker_widget.dart';

class ShareDailyStepProgressCard extends StatelessWidget {
  const ShareDailyStepProgressCard({super.key, required this.progressValue, required this.currentSteps, required this.maxSteps,});

  final double progressValue;
  final int currentSteps;
  final int maxSteps;

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEEE, d MMM yyyy').format(DateTime.now()),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFA5A5A5),
                          fontSize: 11.sp,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/zest_green.svg',
                        height: 25.h,
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: StepsTrackerWidget(
                      progressValue: progressValue,
                      currentSteps: currentSteps,
                      maxSteps: maxSteps,
                      showIconShoes: false,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text(
                      (currentSteps >= maxSteps) 
                      ? "Goal reached! Awesome job hitting your step target today!" 
                      : 'Just ${NumberHelper().formatNumberToKWithComma(maxSteps - currentSteps)} Stepss To Crush Your Goal!',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white, // Teks harus putih agar shader terlihat
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text(
                      "Your turn to flex this badge",
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: Colors.white, // Teks harus putih agar shader terlihat
                      ),
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
}