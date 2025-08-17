import 'package:get/get.dart';

import '../controllers/share_daily_streak_controller.dart';

class ShareDailyStreakBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShareDailyStreakController(
      title: Get.arguments['title'],
      description: Get.arguments['description'],
      imageUrl: Get.arguments['imageUrl'],
    ));
  }
}