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
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.backgroundColor = Colors.white,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap == null ? null : onTap!(),
      child: Container(
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: border ?? Border.all(color: Colors.transparent),
        ),
        child: child,
      ),
    );
  }
}
