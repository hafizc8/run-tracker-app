import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class MainProfileSkeleton extends StatelessWidget {
  const MainProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            height: 256,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerCircle(size: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: 120, height: 16), // nama
                      SizedBox(height: 8),
                      ShimmerBox(width: 80, height: 14), // lokasi
                      SizedBox(height: 8),
                      ShimmerBox(width: 200, height: 40), // bio
                    ],
                  ),
                ),
                const Icon(Icons.settings_outlined, color: Colors.grey),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Badges skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF2E2E2E),
                ),
                child: Column(
                  children: const [
                    ShimmerCircle(size: 50),
                    SizedBox(height: 5),
                    ShimmerBox(width: 40, height: 12),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Overall mileage
          const ShimmerBox(width: double.infinity, height: 39),

          const SizedBox(height: 24),

          // Tab bar placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ShimmerBox(width: 60, height: 20),
              ShimmerBox(width: 60, height: 20),
              ShimmerBox(width: 60, height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
