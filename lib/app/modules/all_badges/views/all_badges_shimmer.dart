import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Widget utama yang akan Anda panggil di view.
class AllBadgesShimmer extends StatelessWidget {
  const AllBadgesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus kerangka dengan efek Shimmer
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      period: const Duration(milliseconds: 1500),
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: _AllBadgesShimmerLayout(),
      ),
    );
  }
}

/// Widget yang berisi struktur kerangka dari halaman AllBadges.
class _AllBadgesShimmerLayout extends StatelessWidget {
  const _AllBadgesShimmerLayout();

  @override
  Widget build(BuildContext context) {
    // Tampilkan placeholder untuk 3 kategori
    return Column(
      children: List.generate(3, (_) => const _CategoryPlaceholder()),
    );
  }
}

/// Placeholder untuk satu blok kategori (judul + grid).
class _CategoryPlaceholder extends StatelessWidget {
  const _CategoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder untuk judul kategori
          _BoxPlaceholder(height: 20.h, width: 120.w),
          SizedBox(height: 12.h),

          // Placeholder untuk GridView badge
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: 6, // Tampilkan 6 placeholder badge per kategori
            itemBuilder: (context, index) => const _BadgePlaceholder(),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

/// Placeholder untuk satu kartu badge di dalam grid.
class _BadgePlaceholder extends StatelessWidget {
  const _BadgePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[800], // Warna dasar placeholder
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _CirclePlaceholder(size: 50.r)),
          const SizedBox(height: 8),
          _BoxPlaceholder(height: 11.sp, width: 60.w),
        ],
      ),
    );
  }
}

// --- Widget Bantuan untuk Bentuk Dasar ---
class _BoxPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  const _BoxPlaceholder({required this.height, required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(4),
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
