import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Widget utama yang akan Anda panggil di view.
class LeaderboardShimmerEffect extends StatelessWidget {
  const LeaderboardShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus kerangka dengan efek Shimmer
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      period: const Duration(milliseconds: 1500),
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: _LeaderboardShimmerLayout(),
      ),
    );
  }
}

/// Widget yang berisi struktur kerangka dari halaman leaderboard.
class _LeaderboardShimmerLayout extends StatelessWidget {
  const _LeaderboardShimmerLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Placeholder untuk Top 3 Podium
        _buildTop3Placeholder(),

        // Placeholder untuk daftar peringkat lainnya
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8, // Tampilkan 8 placeholder list item
          itemBuilder: (context, index) => const _OtherWalkerPlaceholder(),
        ),
      ],
    );
  }
}

/// Placeholder untuk widget Top3WalkersList (Podium).
Widget _buildTop3Placeholder() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 24.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Peringkat 2
        const Expanded(child: _PodiumProfilePlaceholder(isFirstPlace: false)),
        SizedBox(width: 16.w),
        // Peringkat 1
        const Expanded(child: _PodiumProfilePlaceholder(isFirstPlace: true)),
        SizedBox(width: 16.w),
        // Peringkat 3
        const Expanded(child: _PodiumProfilePlaceholder(isFirstPlace: false)),
      ],
    ),
  );
}

/// Placeholder untuk satu profil di podium.
class _PodiumProfilePlaceholder extends StatelessWidget {
  final bool isFirstPlace;
  const _PodiumProfilePlaceholder({required this.isFirstPlace});

  @override
  Widget build(BuildContext context) {
    final double avatarSize = isFirstPlace ? 120.r : 90.r;
    final double rankBadgeSize = isFirstPlace ? 40.r : 30.r;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _CirclePlaceholder(size: avatarSize),
            Positioned(
              bottom: -rankBadgeSize / 2.5,
              child: _CirclePlaceholder(size: rankBadgeSize),
            )
          ],
        ),
        SizedBox(height: rankBadgeSize / 2 + 12.h),
        _BoxPlaceholder(height: 16, width: 60.w),
        SizedBox(height: 6.h),
        _BoxPlaceholder(height: 14, width: 70.w),
      ],
    );
  }
}

/// Placeholder untuk satu baris di ListView (_OthersWalkers).
class _OtherWalkerPlaceholder extends StatelessWidget {
  const _OtherWalkerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 10,
        top: 10,
        left: 18,
        right: 18,
      ),
      child: Row(
        children: [
          _BoxPlaceholder(height: 12, width: 25.w),
          SizedBox(width: 10.w),
          _CirclePlaceholder(size: 27.r),
          SizedBox(width: 12.w),
          _BoxPlaceholder(height: 12, width: 100.w),
          const Spacer(),
          _BoxPlaceholder(height: 12, width: 50.w),
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
        color: Colors.grey[800],
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
        color: Colors.grey[800],
        shape: BoxShape.circle,
      ),
    );
  }
}
