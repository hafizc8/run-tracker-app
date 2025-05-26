import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ActivityAttribute extends StatelessWidget {
  ActivityAttribute({super.key, required this.attributes});

  List<Map<String, dynamic>> attributes = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: attributes.map((attr) {
        return buildActivityAttribute(
          context: context, 
          title: attr['title'], 
          icon: attr['icon'], 
          data: attr['data'],
        );
      }).toList(),
    );
  }

  Widget buildActivityAttribute({
    required BuildContext context,
    required String title,
    required String icon,
    required String data,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/$icon.svg'),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color:
                            Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  data,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}