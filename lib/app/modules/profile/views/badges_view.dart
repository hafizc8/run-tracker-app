import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/activity/controllers/activity_controller.dart';

class BadgesView extends GetView<ActivityController> {
  const BadgesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Badges'),
          automaticallyImplyLeading: false,
          elevation: 1,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.chevron_left,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(
            6,
            (index) => Container(
              width: 125,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Placeholder(fallbackHeight: 40, fallbackWidth: 100),
                  SizedBox(height: 5),
                  Text(
                    'item',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
