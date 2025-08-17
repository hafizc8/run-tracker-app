import 'package:get/get.dart';
import '../controllers/share_daily_step_progress_controller.dart';

class ShareDailyStepProgressBinding extends Bindings {
  @override
  void dependencies() {
    final progressValue = Get.arguments['progressValue'];
    final currentSteps = Get.arguments['currentSteps'];
    final maxSteps = Get.arguments['maxSteps'];

    Get.put(ShareDailyStepProgressController(
      progressValue: progressValue,
      currentSteps: currentSteps,
      maxSteps: maxSteps
    ));
  }
}