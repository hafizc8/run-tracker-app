import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class StepsTrackerWidget extends StatelessWidget {
  final double progressValue; // Nilai progress antara 0.0 dan 1.0
  final int currentSteps;
  final int maxSteps;

  const StepsTrackerWidget({
    Key? key,
    required this.progressValue,
    required this.currentSteps,
    this.maxSteps = 30000, // Nilai maksimum default seperti di gambar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Membuat widget menjadi persegi
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Custom painter untuk circular progress dan label angka
          CustomPaint(
            painter: _StepsProgressPainter(
              context: context,
              progress: progressValue,
              maxSteps: maxSteps,
            ),
            size: Size.infinite, // Mengisi ruang yang tersedia
          ),
          // Ikon di tengah
          SvgPicture.asset(
            'assets/icons/ic_shoes_3.svg',
            width: 110,
            height: 110,
          ),
          // Teks nilai di bawah
          Positioned(
            bottom: 10.0, // Sesuaikan posisi
            child: Text(
              NumberHelper().formatNumberToKWithComma(currentSteps),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                fontSize: 35,
                color: darkColorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsProgressPainter extends CustomPainter {
  final double progress;
  final int maxSteps;
  final BuildContext context;

  _StepsProgressPainter({required this.context, required this.progress, required this.maxSteps});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - 10;
    const strokeWidth = 13.0;
    const arcAngle = math.pi * 1.5;
    const startAngle = math.pi * 0.75;

    final backgroundPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.lightGreenAccent.withOpacity(0.8), Colors.green.withOpacity(0.9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      arcAngle,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      arcAngle * progress,
      false,
      progressPaint,
    );

    // --- MULAI PERUBAHAN DINAMIS DI SINI ---

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final textStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: const Color(0xFF6C6C6C),
          fontSize: 15,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );
        
    // 1. Menentukan jumlah label yang diinginkan
    const int numLabels = 6;

    // 2. Membuat Map kosong untuk menampung data label yang dinamis
    final Map<String, double> labelsData = {};

    // 3. Looping untuk men-generate setiap label dan posisinya
    for (int i = 1; i <= numLabels; i++) {
      // Menghitung posisi secara matematis agar jaraknya selalu rata
      // Kita bagi busur menjadi (numLabels + 1) segmen, lalu letakkan label di setiap batas segmen.
      final double positionFraction = i / (numLabels + 1);

      // Menghitung nilai ideal untuk setiap langkah
      final double idealValue = (maxSteps / numLabels) * i;
      
      // Membulatkan nilai ke kelipatan 50 terdekat untuk UX yang baik
      // (Anda bisa ubah 50 ke 100 jika ingin pembulatan yang lebih besar)
      int labelValue = (idealValue / 25).round() * 25;
      
      // Memastikan label terakhir adalah maxSteps untuk presisi
      if (i == numLabels) {
        labelValue = maxSteps;
      }
      
      // Menggunakan NumberHelper Anda untuk memformat angka (contoh: 5.000 menjadi 5k)
      final String labelText = NumberHelper().formatNumberToKWithComma(labelValue);

      // Menambahkan data yang sudah dinamis ke map
      labelsData[labelText] = positionFraction;
    }
    
    // --- AKHIR PERUBAHAN DINAMIS ---
    
    final textRadius = radius - strokeWidth / 2 - 35;

    labelsData.forEach((text, positionFraction) {
      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.layout();

      final currentAngle = startAngle + (arcAngle * positionFraction);
      final x = center.dx + textRadius * math.cos(currentAngle);
      final y = center.dy + textRadius * math.sin(currentAngle);

      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    });
  }

  @override
  bool shouldRepaint(covariant _StepsProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.maxSteps != maxSteps;
  }
}