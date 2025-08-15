import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    // Tentukan ukuran kanvas untuk rasio 9:16
    // Kita bisa menggunakan tinggi yang tetap dan menghitung lebar
    // Atau menggunakan ScreenUtil untuk ukuran relatif.
    // Untuk tujuan screenshot, kita gunakan ukuran standar agar konsisten.
    // Misalnya, anggap tinggi 1920px untuk lebar 1080px (FHD potret)
    // Atau ukuran yang sedikit lebih kecil yang proporsional 9:16
    final double wrapperWidth = 430.w; // Mengambil lebar dari designSize ScreenUtil
    final double wrapperHeight = 932.h; // Mengambil tinggi dari designSize ScreenUtil

    return Container(
      width: wrapperWidth,
      height: wrapperHeight,
      // Beri warna latar belakang default jika tidak ada gambar
      color: darkColorScheme.surface, 
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image (dari asset)
          if (backgroundImagePath != null && backgroundImagePath!.isNotEmpty)
            Positioned.fill(
              child: Image.asset(
                backgroundImagePath!,
                fit: BoxFit.cover,
              ),
            ),

          // Kartu Profil Anda (ditempatkan di tengah)
          Center(
            child: shareCard,
          ),
        ],
      ),
    );
  }
}
