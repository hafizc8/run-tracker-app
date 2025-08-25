import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';

class CustomExpProgressBar extends StatelessWidget {
  /// Nilai EXP saat ini.
  final int currentExp;

  /// Nilai EXP maksimal untuk level ini.
  final int maxExp;

  /// Tinggi dari progress bar.
  final double height;

  const CustomExpProgressBar({
    super.key,
    required this.currentExp,
    required this.maxExp,
    this.height = 28.0, // Anda bisa sesuaikan tinggi defaultnya
  });

  @override
  Widget build(BuildContext context) {
    // Mengambil warna dari tema aplikasi Anda
    final colorScheme = Theme.of(context).colorScheme;

    // Menghitung progress sebagai nilai antara 0.0 dan 1.0
    // .clamp memastikan nilainya tidak kurang dari 0 atau lebih dari 1
    final double progress = (currentExp / maxExp).clamp(0.0, 1.0);

    return SizedBox(
      height: height,
      // ClipRRect digunakan untuk memberikan border radius pada Stack
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15), // Sesuaikan radius sesuai keinginan
        child: Stack(
          children: [
            // 1. Lapisan Bawah (Background)
            // Container ini mengisi seluruh ruang yang tersedia
            Container(
              color: const Color(0xFF595959), // Warna untuk bagian yang belum tercapai
            ),

            // 2. Lapisan Tengah (Progress)
            // FractionallySizedBox sangat cocok untuk membuat progress bar
            // karena ia akan mengisi sebagian dari parent-nya berdasarkan widthFactor.
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colorScheme.primary,
                ),
              ),
            ),

            // 3. Lapisan Atas (Teks)
            // Center memastikan teks berada tepat di tengah
            Center(
              child: Text(
                '${NumberHelper().formatNumberToKWithComma(currentExp)} / ${NumberHelper().formatNumberToKWithComma(maxExp)}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: const Color(0xFF292929),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}