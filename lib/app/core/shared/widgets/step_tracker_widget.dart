import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

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
            width: 130,
            height: 130,
          ),
          // Teks nilai di bawah
          Positioned(
            bottom: 40.0, // Sesuaikan posisi
            child: Text(
              currentSteps.toString(), // Anda mungkin ingin memformat angka ini (misal: 17.000)
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
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
    // Radius dikurangi sedikit lebih banyak untuk memberi ruang bagi teks di dalam
    final radius = math.min(size.width / 2, size.height / 2) - 10; // Jarak dari tepi luar widget
    const strokeWidth = 13.0; // Ketebalan progress bar
    const arcAngle = math.pi * 1.5; // Total sudut busur (270 derajat)
    const startAngle = math.pi * 0.75; // Mulai dari sudut kiri atas (sesuaikan)

    // Paint untuk background abu-abu
    final backgroundPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Paint untuk progress hijau
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.lightGreenAccent.withOpacity(0.8), Colors.green.withOpacity(0.9)], // Sedikit transparan agar lebih mirip
         begin: Alignment.topLeft, // Sesuaikan gradien
         end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Gambar background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      arcAngle,
      false,
      backgroundPaint,
    );

    // Gambar progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      arcAngle * progress,
      false,
      progressPaint,
    );

    // Gambar label angka di dalam busur
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    // Gaya teks diubah menjadi italic
    final textStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: const Color(0xFF6C6C6C),
        fontSize: 15,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
    );

    // Daftar label dan persentase posisi pada busur (0.0 hingga 1.0 dari total busur)
    // Posisi 0.0 adalah awal busur, 1.0 adalah akhir busur
    final labelsData = {
      // 'Angka': PersentasePosisi (0.0 - 1.0 dari panjang busur)
      '5000': 0.10,  // Sedikit setelah awal
      '10000': 0.25,
      '15000': 0.40,
      '20000': 0.61, // Tengah atas busur (3/4 * 2/3)
      // '20000': (1.5 * math.pi - startAngle) / arcAngle, // Tepat di puncak busur (jika startAngle 0.75pi dan arcAngle 1.5pi)
                                                           // Seharusnya (1.5*pi - 0.75*pi) / (1.5*pi) = 0.5
      '25000': 0.75,
      '30000': 0.90, // Sedikit sebelum akhir
    };

    // Penyesuaian radius untuk menempatkan teks di dalam jalur progress bar
    // Radius untuk teks lebih kecil dari radius busur luar, dan lebih besar dari radius busur dalam
    final textRadius = radius - strokeWidth / 2 - 35; // Offset agar teks berada di dalam dan tidak terlalu dekat tepi

    labelsData.forEach((text, positionFraction) {
      textPainter.text = TextSpan(text: text, style: textStyle);
      textPainter.layout();

      // Hitung sudut aktual berdasarkan fraksi posisi pada busur
      // Sudut dihitung relatif terhadap startAngle dan panjang busur (arcAngle)
      final currentAngle = startAngle + (arcAngle * positionFraction);

      // Perhitungan posisi (x, y) berdasarkan sudut dan textRadius
      // Perlu diingat bahwa 0 radian adalah di kanan, sumbu Y positif ke bawah.
      // Jadi kita perlu melakukan offset pada sudut agar sesuai dengan orientasi visual.
      // Sudut pada sistem koordinat Cartesian umumnya diukur berlawanan arah jarum jam dari sumbu X positif.
      // Sudut pada canvas.drawArc diukur searah jarum jam dari jam 3.
      // Untuk `math.cos` dan `math.sin`, sudut 0 adalah sumbu X positif.
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

// Cara menggunakan widget di aplikasi Anda:
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       backgroundColor: Colors.grey[850], // Background gelap seperti di gambar
//       body: Center(
//         child: Container(
//           width: 300, // Sesuaikan ukuran
//           height: 300,
//           child: StepsTrackerWidget(
//             progressValue: 17000 / 30000.0, // Contoh: 17000 dari 30000 langkah
//             currentSteps: 17000,
//             maxSteps: 30000,
//           ),
//         ),
//       ),
//     ),
//   ));
// }