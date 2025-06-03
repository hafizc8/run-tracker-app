import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class SocialActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  const SocialActionButton({
    super.key, 
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Visibility(
        visible: selected,
        replacement: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF393939),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(child: icon),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF2F4A00),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: darkColorScheme.primary, width: 1),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}