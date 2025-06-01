import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget child;
  final Function? onTap;
  final Color backgroundColor;
  final EdgeInsets padding;
  final Border? border;

  const CustomChip({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.backgroundColor = Colors.transparent,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap == null ? null : onTap!(),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: border ?? Border.all(color: Colors.transparent),
        ),
        child: child,
      ),
    );
  }
}
