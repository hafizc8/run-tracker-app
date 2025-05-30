import 'package:flutter/material.dart';
// Pastikan konstanta gradient ini didefinisikan atau diimpor
// Misalnya dari file tema Anda:
// import 'package:zest_mobile/app/core/shared/theme/elevated_btn_theme.dart';

const LinearGradient kAppDefaultButtonGradient = LinearGradient(
  colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const LinearGradient kAppDisabledButtonGradient = LinearGradient(
  colors: [Color(0xFFBDBDBD), Color(0xFFBDBDBD)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

class GradientBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;
  final OutlinedBorder shape;

  GradientBorderPainter({
    required this.strokeWidth,
    required this.gradient,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (strokeWidth <= 0) return;

    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    final Path path = shape.getOuterPath(rect.deflate(strokeWidth / 2.0));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.gradient != gradient ||
           oldDelegate.shape != shape;
  }
}

class GradientOutlinedButton extends StatelessWidget {
  final Widget child; // ✨ Diubah dari String text menjadi Widget child
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Gradient? disabledGradient;
  final double borderWidth;
  final ButtonStyle? style; // Untuk mengambil shape, minSize dari tema atau override
  final EdgeInsetsGeometry? contentPadding;

  const GradientOutlinedButton({
    super.key,
    required this.child, // ✨ Konstruktor diperbarui
    required this.onPressed,
    this.gradient,
    this.disabledGradient,
    this.borderWidth = 1.5,
    this.style,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final ThemeData theme = Theme.of(context);
    
    final ButtonStyle? themeButtonStyle = theme.outlinedButtonTheme.style;
    final ButtonStyle effectiveStyle = (themeButtonStyle ?? const ButtonStyle()).merge(style);

    final Gradient currentGradient = enabled
        ? (gradient ?? kAppDefaultButtonGradient)
        : (disabledGradient ?? kAppDisabledButtonGradient);
    
    final OutlinedBorder effectiveShape = effectiveStyle.shape?.resolve({}) ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)); 

    final EdgeInsetsGeometry finalContentPadding = contentPadding ??
        effectiveStyle.padding?.resolve({}) ?? // Ambil padding dari tema jika ada, jika tidak default
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    final Size? minSize = effectiveStyle.minimumSize?.resolve({});

    return Material(
      type: MaterialType.transparency,
      shape: effectiveShape,
      child: InkWell(
        onTap: onPressed,
        customBorder: effectiveShape,
        splashColor: currentGradient is LinearGradient
            ? (currentGradient as LinearGradient).colors.first.withOpacity(0.12)
            : Colors.grey.withOpacity(0.12),
        highlightColor: currentGradient is LinearGradient
            ? (currentGradient as LinearGradient).colors.first.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        child: CustomPaint(
          painter: GradientBorderPainter(
            strokeWidth: borderWidth,
            gradient: currentGradient,
            shape: effectiveShape,
          ),
          child: Container(
            padding: finalContentPadding,
            constraints: minSize != null ? BoxConstraints(minHeight: minSize.height) : null,
            alignment: Alignment.center,
            child: ShaderMask( // ShaderMask sekarang akan menerapkan gradient ke 'widget.child' apapun
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => currentGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: child, // ✨ Menggunakan widget.child di sini
            ),
          ),
        ),
      ),
    );
  }
}