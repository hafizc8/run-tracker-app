import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Widget utama yang akan Anda panggil di view
class ActivityCardShimmer extends StatelessWidget {
  const ActivityCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus kerangka dengan efek Shimmer
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3, // Tampilkan 3 placeholder card
        itemBuilder: (context, index) => const _ActivityCardPlaceholder(),
      ),
    );
  }
}

// Widget yang berisi struktur kerangka dari satu ActivityCard
class _ActivityCardPlaceholder extends StatelessWidget {
  const _ActivityCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder untuk Header
          _buildHeaderPlaceholder(),
          SizedBox(height: 8.h),
          // Placeholder untuk Konten (Title & Content)
          _buildContentPlaceholder(),
          SizedBox(height: 15.h),
          // Placeholder untuk Media (Peta/Gambar)
          _BoxPlaceholder(height: 210.h, width: double.infinity),
          SizedBox(height: 15.h),
          // Placeholder untuk Social Actions
          _buildActionsPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildHeaderPlaceholder() {
    return Row(
      children: [
        const _CirclePlaceholder(size: 30),
        SizedBox(width: 8.w),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BoxPlaceholder(height: 14, width: 120),
            SizedBox(height: 4),
            _BoxPlaceholder(height: 11, width: 80),
          ],
        ),
        const Spacer(),
        const _BoxPlaceholder(height: 11, width: 50),
      ],
    );
  }

  Widget _buildContentPlaceholder() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BoxPlaceholder(height: 12, width: 250),
        SizedBox(height: 5),
        _BoxPlaceholder(height: 12, width: 200),
      ],
    );
  }

  Widget _buildActionsPlaceholder() {
    return Row(
      children: [
        Expanded(child: _BoxPlaceholder(height: 35, width: double.infinity, borderRadius: 20.r)),
        SizedBox(width: 8.w),
        Expanded(child: _BoxPlaceholder(height: 35, width: double.infinity, borderRadius: 20.r)),
        SizedBox(width: 8.w),
        Expanded(child: _BoxPlaceholder(height: 35, width: double.infinity, borderRadius: 20.r)),
      ],
    );
  }
}

// --- Widget Bantuan untuk Placeholder ---

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
        color: Colors.grey[850], // Warna yang sedikit lebih gelap dari card
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
      height: size.r,
      width: size.r,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        shape: BoxShape.circle,
      ),
    );
  }
}
