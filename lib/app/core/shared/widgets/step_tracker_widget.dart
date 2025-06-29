import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    this.maxSteps = 30000,
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
            height: 0.15.sh,
          ),
          // Teks nilai di bawah
          Positioned(
            bottom: 10.0, // Sesuaikan posisi
            child: Text(
              NumberHelper().formatNumberToKWithComma(currentSteps),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                fontSize: 35.sp, // Dibuat responsif
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

    // --- LOGIKA PERHITUNGAN LABEL YANG DIPERBAIKI ---

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final textStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: const Color(0xFF6C6C6C),
          fontSize: 15.sp, // Dibuat responsif
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );
        
    const int numLabels = 5;
    final Map<String, double> labelsData = {};

    // ✨ 1. Tambahkan label "0" secara manual di posisi awal ✨
    labelsData["0"] = 0.0;

    for (int i = 1; i <= numLabels; i++) {
      // ✨ 2. Kalkulasi posisi yang presisi ✨
      // Fraksi posisi sekarang sama dengan fraksi nilai (misal: 1/5, 2/5, dst.)
      // Ini akan menempatkan label 20% nilai di 20% busur, 40% di 40%, dst.
      final double positionFraction = i / numLabels;

      final double idealValue = (maxSteps / numLabels) * i;
      int labelValue = (idealValue / 25).round() * 25;
      
      if (i == numLabels) {
        labelValue = maxSteps;
      }
      
      final String labelText = NumberHelper().formatNumberToKWithComma(labelValue);
      labelsData[labelText] = positionFraction;
    }
    
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
