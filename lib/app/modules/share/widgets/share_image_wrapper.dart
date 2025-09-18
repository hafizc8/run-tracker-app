import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart'; // Sesuaikan path ini

class ShareImageWrapper extends StatelessWidget {
  final Widget shareCard; // Widget kartu profil yang sudah ada
  final String? backgroundImagePath; // Path ke gambar background (opsional)
  final double wrapperWidth;
  final double wrapperHeight;

  const ShareImageWrapper({
    super.key,
    required this.shareCard,
    this.backgroundImagePath,
    this.wrapperWidth = 1080,
    this.wrapperHeight = 1920,
  });

  @override
  Widget build(BuildContext context) {
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
