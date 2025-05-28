import 'package:flutter/material.dart';
// Pastikan konstanta gradient ini didefinisikan atau diimpor.
// Jika mereka ada di 'elevated_btn_theme.dart', import tersebut sudah cukup.
// Untuk contoh ini, saya akan definisikan di sini agar widget lebih mandiri.
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

class GradientElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Gradient? disabledGradient;
  final ButtonStyle? style;
  final EdgeInsetsGeometry? contentPadding;

  const GradientElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.gradient,
    this.disabledGradient,
    this.style,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? themeButtonStyle = Theme.of(context).elevatedButtonTheme.style;
    final ButtonStyle effectiveStyle = (themeButtonStyle ?? const ButtonStyle()).merge(style);

    final Gradient currentGradient = (onPressed == null
            ? (disabledGradient ?? kAppDisabledButtonGradient)
            : (gradient ?? kAppDefaultButtonGradient));

    final EdgeInsetsGeometry finalContentPadding =
        contentPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    
    BorderRadius borderRadius = BorderRadius.circular(100.0);
    final MaterialStateProperty<OutlinedBorder?>? shapeProperty = effectiveStyle.shape;
    if (shapeProperty != null) {
      final OutlinedBorder? border = shapeProperty.resolve({});
      if (border is RoundedRectangleBorder) {
        borderRadius = border.borderRadius.resolve(Directionality.of(context));
      }
    }

    final Size? minSize = effectiveStyle.minimumSize?.resolve({});

    return ElevatedButton(
      onPressed: onPressed,
      style: effectiveStyle.copyWith(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black.withOpacity(0.12); // Warna overlay saat ditekan
          }
          return null; 
        }),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: currentGradient,
          borderRadius: borderRadius,
        ),
        child: Container(
          padding: finalContentPadding,
          alignment: Alignment.center,
          constraints: minSize != null ? BoxConstraints(minHeight: minSize.height) : null,
          child: child,
        ),
      ),
    );
  }
}