import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCircularProgressIndicator extends StatelessWidget {
  CustomCircularProgressIndicator({super.key, this.indicatorSize = 22});

  double indicatorSize = 22;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 2.5, // Anda bisa menyesuaikan ketebalan garis
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}