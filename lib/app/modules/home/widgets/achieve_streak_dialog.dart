import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/models/model/popup_notification_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class AchieveStreakDialog extends StatelessWidget {
  final PopupNotificationModel notification;

  const AchieveStreakDialog({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = notification.data as Map<String, dynamic>?; // Cast 'data'

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: const LinearGradient(
            colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2E2E2E),
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Konten Utama ---
              Text(
                "Nice Work!\nYou've Hit ${NumberHelper().formatNumberToKWithComma(data?['daily_step_goals'])} Steps Today",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: const Color(0xFFA2FF00),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14.h),
              if (notification.imageUrl != null)
                CachedNetworkImage(
                  imageUrl: notification.imageUrl!,
                  height: 150.h,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              
              SizedBox(height: 12.h),
              Text(
                "+${data?['xp']} XP",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: const Color(0xFFA2FF00),
                )
              ),
              SizedBox(height: 4.h),
              Text(
                'Comeback tomorrow\nand keep the momentum going!',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),
              
              // --- Tombol Aksi ---
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: GradientOutlinedButton(
                        contentPadding: const EdgeInsets.all(0),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        onPressed: () => Get.back(result: 'back'),
                        child: Text(
                          'Back',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 38.h,
                      child: GradientElevatedButton(
                        contentPadding: const EdgeInsets.all(0),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        onPressed: () {
                          // Get.toNamed(
                          //   AppRoutes.shareDailyGoals,
                          //   arguments: {
                          //     'title': notification.data['title'],
                          //     'description': notification.data['description'],
                          //     'imageUrl': notification.imageUrl,
                          //   }
                          // );
                          Get.back(result: 'share');
                        },
                        // ✨ Bangun child tombol secara dinamis
                        child: Text(
                          'Share',
                          style: GoogleFonts.poppins(
                            fontSize: 12, 
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF292929),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardRow(String iconPath, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(iconPath, height: 23.w),
        SizedBox(width: 12.w),
        Text(
          text,
          style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp,
            color: darkColorScheme.primary,
          ),
        ),
      ],
    );
  }
}
