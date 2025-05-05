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
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

  }
}