import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Widget utama yang akan Anda panggil di view.
class DailyStreakShimmer extends StatelessWidget {
  const DailyStreakShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus kerangka dengan efek Shimmer
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      period: const Duration(milliseconds: 1500),
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: _DailyStreakShimmerLayout(),
      ),
    );
  }
}

/// Widget yang berisi struktur kerangka dari halaman Daily Streak.
class _DailyStreakShimmerLayout extends StatelessWidget {
  const _DailyStreakShimmerLayout();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          // Placeholder untuk "Total Daily Streak"
          _BoxPlaceholder(height: 45.h, width: double.infinity, borderRadius: 10.r),
          SizedBox(height: 16.h),

          // Placeholder untuk Kalender
          _buildCalendarPlaceholder(),
          SizedBox(height: 15.h),
          
          // Placeholder untuk Kartu Detail XP
          _buildXpDetailsPlaceholder(),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}

/// Placeholder untuk seluruh bagian kalender.
Widget _buildCalendarPlaceholder() {
  return Column(
    children: [
      // Header (Tombol prev, bulan, tombol next)
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CirclePlaceholder(size: 25.r),
            _BoxPlaceholder(height: 20, width: 150.w),
            _CirclePlaceholder(size: 25.r),
          ],
        ),
      ),
      SizedBox(height: 10.h),
      // Nama-nama hari
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (_) => _BoxPlaceholder(height: 14, width: 20.w)),
      ),
      SizedBox(height: 10.h),
      // Grid tanggal
      ...List.generate(5, (rowIndex) { // 5 baris tanggal
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) { // 7 hari per baris
              return const _CalendarDayPlaceholder();
            }),
          ),
        );
      }),
    ],
  );
}

/// Placeholder untuk satu sel tanggal di kalender.
class _CalendarDayPlaceholder extends StatelessWidget {
  const _CalendarDayPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CirclePlaceholder(size: 28.r),
        SizedBox(height: 4.h),
        _BoxPlaceholder(height: 10, width: 15.w),
      ],
    );
  }
}

/// Placeholder untuk kartu detail XP.
Widget _buildXpDetailsPlaceholder() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Column(
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(10.r),
          ),
          height: 48.h,
        ),
        // Konten
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (_) => const _XpColumnPlaceholder()),
          ),
        ),
        // Total XP
        _BoxPlaceholder(height: 14, width: 150.w),
        SizedBox(height: 15.h),
      ],
    ),
  );
}

/// Placeholder untuk satu kolom di detail XP.
class _XpColumnPlaceholder extends StatelessWidget {
  const _XpColumnPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BoxPlaceholder(height: 12, width: 50.w),
        SizedBox(height: 4.h),
        _BoxPlaceholder(height: 12, width: 50.w),
        SizedBox(height: 8.h),
        _BoxPlaceholder(height: 12, width: 20.w),
      ],
    );
  }
}


// --- Widget Bantuan untuk Bentuk Dasar ---
class _BoxPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final double? borderRadius;

  const _BoxPlaceholder({
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
      ),
    );
  }
}

class _CirclePlaceholder extends StatelessWidget {
  final double size;
  const _CirclePlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        shape: BoxShape.circle,
      ),
    );
  }
}
