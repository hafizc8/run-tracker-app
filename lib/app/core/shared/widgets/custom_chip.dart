import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget child;
  final Function? onTap;
  final Color backgroundColor;

  const CustomChip({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: child,
      ),
    );
  }
}
