import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Widget untuk menampilkan kartu tantangan di halaman leaderboard.
class LeaderboardChallengeCard extends StatelessWidget {
  final String challengeType; // e.g., "Team"
  final String title;
  final String mode;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback? onTap;

  const LeaderboardChallengeCard({
    super.key,
    required this.challengeType,
    required this.title,
    required this.mode,
    required this.startDate,
    required this.endDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: Tipe Tantangan (Team/Individual)
            _buildTypeChip(context, challengeType),
            SizedBox(height: 16.h),

            // Judul Utama
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFA2FF00),
                  Color(0xFF00FF7F),
                ],
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.sp,
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Mode Tantangan
            Text(
              mode,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // Teks "Challenge Overview"
            Text(
              'Challenge Overview',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // Baris bawah: Tanggal Mulai dan Selesai
            Row(
              children: [
                _buildDateInfo(
                  context: context,
                  iconAsset: 'assets/icons/ic_date.svg',
                  label: 'Start Date',
                  date: startDate,
                ),
                SizedBox(width: 24.w),
                _buildDateInfo(
                  context: context,
                  iconAsset: 'assets/icons/ic_date.svg',
                  label: 'End Date',
                  date: endDate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk chip tipe tantangan (misal: "Team")
  Widget _buildTypeChip(BuildContext context, String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF404040),
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_team.svg',
            height: 17.h,
            colorFilter: const ColorFilter.mode(Color(0xFFDCDCDC), BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Text(
            type,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: const Color(0xFFDCDCDC),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan informasi tanggal
  Widget _buildDateInfo({
    required BuildContext context,
    required String iconAsset,
    required String label,
    required DateTime date,
  }) {
    // Format tanggal menjadi "dd MMMM yyyy" (e.g., "01 May 2025")
    final formattedDate = DateFormat('dd MMMM yyyy').format(date);

    return Flexible(
      child: Row(
        children: [
          SvgPicture.asset(
            iconAsset,
            height: 24.h,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFA5A5A5),
                  fontSize: 12.sp,
                ),
              ),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
