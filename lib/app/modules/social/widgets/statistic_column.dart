import 'package:flutter/material.dart';

class StatisticsColumn extends StatelessWidget {
  final String title;
  final String value;
  
  const StatisticsColumn({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  }
}