// Letakkan widget ini di file yang sama atau file terpisah
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class WalkerProfile extends StatelessWidget {
  final String rank;
  final String imageUrl;
  final String name;
  final Color? backgroundColor; // Opsional untuk latar belakang khusus

  const WalkerProfile({
    super.key, 
    required this.rank,
    required this.imageUrl,
    required this.name,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan ColorScheme dari tema saat ini
    final darkColorScheme = Theme.of(context).colorScheme;

    return Container(
      // Dekorasi hanya diterapkan jika backgroundColor tidak null
      decoration: backgroundColor != null
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      padding: EdgeInsets.symmetric(
        vertical: 16, 
        horizontal: backgroundColor != null ? 24 : 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar Column tidak memakan ruang berlebih
        children: [
          Text(
            rank,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: darkColorScheme.primary,
                  fontSize: 17,
                ),
          ),
          const SizedBox(height: 8),
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerLoadingCircle(size: 44),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 22, // Setengah dari width/height
                backgroundImage: AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: darkColorScheme.primary,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}