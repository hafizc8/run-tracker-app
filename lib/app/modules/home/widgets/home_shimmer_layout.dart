import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Widget utama yang membungkus kerangka dengan efek shimmer
class HomeShimmerEffect extends StatelessWidget {
  const HomeShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      period: const Duration(milliseconds: 1500),
      child: const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(), // Nonaktifkan scroll saat loading
        child: HomeShimmerLayout(),
      ),
    );
  }
}

// Widget yang berisi struktur kerangka HomeView
class HomeShimmerLayout extends StatelessWidget {
  const HomeShimmerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // --- Placeholder untuk Profile Bar ---
        _ProfileBarPlaceholder(),

        // --- Placeholder untuk Level ---
        _LevelBarPlaceholder(),

        // --- Placeholder untuk Coin & Energy ---
        _CoinEnergyBarPlaceholder(),

        // --- Placeholder untuk Steps Tracker ---
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 42, vertical: 10),
          child: CirclePlaceholder(size: 270), // Ukuran disesuaikan
        ),

        // --- Placeholder untuk Teks Goal & Stats ---
        BoxPlaceholder(height: 14, width: 250),
        SizedBox(height: 18),
        _StatsBarPlaceholder(),
        SizedBox(height: 24),

        // --- Placeholder untuk Top Walkers ---
        _TopWalkersPlaceholder(),

        // --- Placeholder untuk Challenge Card ---
        _ChallengeCardPlaceholder(),

        SizedBox(height: 36),
      ],
    );
  }
}

// --- Widget Bantuan untuk Placeholder ---

class _ProfileBarPlaceholder extends StatelessWidget {
  const _ProfileBarPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 36, left: 18, right: 18),
      child: const Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoxPlaceholder(height: 20, width: 80),
              SizedBox(height: 8),
              BoxPlaceholder(height: 20, width: 120),
            ],
          ),
          Spacer(),
          CirclePlaceholder(size: 44),
          SizedBox(width: 12),
          CirclePlaceholder(size: 44),
        ],
      ),
    );
  }
}

class _LevelBarPlaceholder extends StatelessWidget {
  const _LevelBarPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18, top: 10),
      child: Row(
        children: [
          const BoxPlaceholder(height: 24, width: 100),
          const SizedBox(width: 8),
          BoxPlaceholder(
            height: 15,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ],
      ),
    );
  }
}

class _CoinEnergyBarPlaceholder extends StatelessWidget {
  const _CoinEnergyBarPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 18, top: 14, bottom: 10),
      child: const Row(
        children: [
          BoxPlaceholder(height: 16, width: 80),
          SizedBox(width: 20),
          BoxPlaceholder(height: 16, width: 100),
        ],
      ),
    );
  }
}

class _StatsBarPlaceholder extends StatelessWidget {
  const _StatsBarPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BoxPlaceholder(height: 14, width: 70),
        SizedBox(width: 20),
        BoxPlaceholder(height: 14, width: 70),
        SizedBox(width: 20),
        CirclePlaceholder(size: 21),
      ],
    );
  }
}

class _TopWalkersPlaceholder extends StatelessWidget {
  const _TopWalkersPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: BoxPlaceholder(height: 16, width: 120),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[800], // Warna dasar card shimmer
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WalkerProfilePlaceholder(),
              _WalkerProfilePlaceholder(),
              _WalkerProfilePlaceholder(),
              _WalkerProfilePlaceholder(),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalkerProfilePlaceholder extends StatelessWidget {
  const _WalkerProfilePlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BoxPlaceholder(height: 17, width: 30),
        SizedBox(height: 8),
        CirclePlaceholder(size: 44),
        SizedBox(height: 8),
        BoxPlaceholder(height: 12, width: 50),
      ],
    );
  }
}

class _ChallengeCardPlaceholder extends StatelessWidget {
  const _ChallengeCardPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: const Row(
        children: [
          BoxPlaceholder(height: 16, width: 200),
          Spacer(),
          CirclePlaceholder(size: 38),
        ],
      ),
    );
  }
}

// Widget placeholder dasar
class BoxPlaceholder extends StatelessWidget {
  final double height;
  final double? width;
  const BoxPlaceholder({super.key, required this.height, this.width});
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

class CirclePlaceholder extends StatelessWidget {
  final double size;
  const CirclePlaceholder({super.key, required this.size});
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
