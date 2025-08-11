import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Widget utama yang akan Anda panggil di view.
class ShareProfileShimmer extends StatelessWidget {
  const ShareProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus kerangka dengan efek Shimmer
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      period: const Duration(milliseconds: 1500),
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: _ShareProfileShimmerLayout(),
      ),
    );
  }
}

/// Widget yang berisi struktur kerangka dari halaman ShareProfile.
class _ShareProfileShimmerLayout extends StatelessWidget {
  const _ShareProfileShimmerLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        // Placeholder untuk Kartu Share
        _buildShareCardPlaceholder(),
        SizedBox(height: 24.h),
        // Placeholder untuk teks "Share to your"
        _BoxPlaceholder(height: 14, width: 120.w),
        SizedBox(height: 16.h),
        // Placeholder untuk Grid Opsi Share
        _buildShareGridPlaceholder(),
        SizedBox(height: 24.h),
      ],
    );
  }
}

/// Placeholder untuk widget ShareCard.
Widget _buildShareCardPlaceholder() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.w),
    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 52.h), // Sisakan ruang untuk footer
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18.r),
      color: Colors.grey[800], // Warna dasar placeholder
    ),
    child: Column(
      children: [
        // Logo
        Align(
          alignment: Alignment.centerRight,
          child: _BoxPlaceholder(height: 25.h, width: 60.w),
        ),
        SizedBox(height: 42.h),
        // Foto Profil
        _CirclePlaceholder(size: 90.r),
        SizedBox(height: 16.h),
        // Nama
        _BoxPlaceholder(height: 17.sp, width: 150.w),
        SizedBox(height: 6.h),
        // Lokasi
        _BoxPlaceholder(height: 12.sp, width: 120.w),
        SizedBox(height: 16.h),
        // Bio
        _BoxPlaceholder(height: 12.sp, width: 250.w),
        SizedBox(height: 4.h),
        _BoxPlaceholder(height: 12.sp, width: 220.w),
        SizedBox(height: 24.h),
        // Statistik
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (_) => const _StatPlaceholder()),
        ),
      ],
    ),
  );
}

/// Placeholder untuk satu kolom statistik.
class _StatPlaceholder extends StatelessWidget {
  const _StatPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BoxPlaceholder(height: 11.sp, width: 60.w),
        SizedBox(height: 6.h),
        _BoxPlaceholder(height: 15.sp, width: 40.w),
      ],
    );
  }
}

/// Placeholder untuk Grid Opsi Share.
Widget _buildShareGridPlaceholder() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 0.8,
    ),
    itemCount: 7, // Jumlah item share
    itemBuilder: (context, index) => const _ShareIconPlaceholder(),
  );
}

/// Placeholder untuk satu ikon di grid share.
class _ShareIconPlaceholder extends StatelessWidget {
  const _ShareIconPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BoxPlaceholder(height: 48.h, width: 48.w, borderRadius: 12.r),
        SizedBox(height: 8.h),
        _BoxPlaceholder(height: 12.sp, width: 60.w),
      ],
    );
  }
}

// --- Widget Bantuan untuk Bentuk Dasar ---
class _BoxPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final double? borderRadius;
  const _BoxPlaceholder({required this.height, required this.width, this.borderRadius});
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
