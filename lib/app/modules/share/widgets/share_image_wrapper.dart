import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart'; // Sesuaikan path ini

class ShareImageWrapper extends StatelessWidget {
  final Widget shareCard; // Widget kartu profil yang sudah ada
  final String? backgroundImagePath; // Path ke gambar background (opsional)

  const ShareImageWrapper({
    super.key,
    required this.shareCard,
    this.backgroundImagePath,
  });

  @override
  Widget build(BuildContext context) {
    // ✨ KUNCI PERBAIKAN: Gunakan ukuran piksel absolut untuk screenshot ✨
    // Ini memastikan rasio 9:16 yang presisi.
    const double wrapperWidth = 1080;  // Lebar standar untuk story
    const double wrapperHeight = 1920; // Tinggi standar untuk story

    return RepaintBoundary(
      child: Container(
        width: wrapperWidth,
        height: wrapperHeight,
        color: darkColorScheme.surface, 
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (backgroundImagePath != null && backgroundImagePath!.isNotEmpty)
              Positioned.fill(
                child: Image.asset(
                  backgroundImagePath!,
                  fit: BoxFit.cover,
                ),
              ),

            Center(
              child: shareCard,
            ),
          ],
        ),
      ),
    );
  }
}
