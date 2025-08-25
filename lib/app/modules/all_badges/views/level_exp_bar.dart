import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';

class LevelExpBar extends StatelessWidget {
  final int level;
  final String levelName;
  final int currentExp;
  final int maxExp;

  const LevelExpBar({
    super.key,
    required this.level,
    required this.levelName,
    required this.currentExp,
    required this.maxExp,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung persentase progres, pastikan tidak lebih dari 1.0
    final double progress = (maxExp > 0 ? currentExp / maxExp : 0.0).clamp(0.0, 1.0);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF585858), // Warna abu-abu gelap
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          // Teks Level dan Nama Level
          RichText(
            text: TextSpan(
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF292929),
                fontWeight: FontWeight.normal,
                fontSize: 14.sp,
              ),
              children: [
                TextSpan(text: 'Level $level '),
                TextSpan(
                  text: levelName,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF292929),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 38.w),
          
          // Progress Bar
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Latar belakang progress bar
                Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF444444),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                // Indikator progres yang terisi
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 20.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                // Teks di atas progress bar
                Text(
                  '${NumberHelper().formatNumberToKWithComma(currentExp)}/${NumberHelper().formatNumberToKWithComma(maxExp)}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF292929),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}