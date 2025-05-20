import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EventShimmer extends StatelessWidget {
  const EventShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Container(
            width: 180,
            height: 24,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          // Image placeholder
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          // Organizer
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 12, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(width: 150, height: 12, color: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Info Rows
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: [
              _infoBlock(),
              _infoBlock(),
              _infoBlock(),
              _infoBlock(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 80, height: 12, color: Colors.white),
        const SizedBox(height: 6),
        Container(width: 100, height: 12, color: Colors.white),
      ],
    );
  }
}
