import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/activity/edit_activity/controllers/edit_activity_controller.dart';

class EditActivityView extends GetView<EditActivityController> {
  const EditActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Edit Activity'),
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
      body: const Center(
        child: Text('Edit Activity under construction'),
      ),
    );
  }
}