import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyComponent extends StatelessWidget {
  const PrivacyPolicyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Privacy Policy'),
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
        child: Text('Privacy Policy'),
      ),
    );
  }
}
