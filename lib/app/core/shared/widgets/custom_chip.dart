import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget child;
  final Function? onTap;
  final Color backgroundColor;
  final EdgeInsets padding;

  const CustomChip({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: child,
      ),
    );
  }
}
