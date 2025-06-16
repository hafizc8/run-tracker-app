import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Pastikan path import ini benar sesuai struktur proyek Anda
import 'package:zest_mobile/app/core/shared/widgets/step_tracker_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Obx(() {
                if (controller.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.error,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                
                // Jika tidak ada error, tampilkan widget tracker.
                return StepsTrackerWidget(
                  progressValue: controller.progressValue,
                  currentSteps: controller.currentSteps,
                  maxSteps: controller.maxSteps,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
