import 'package:get/get.dart';

import '../controllers/share_daily_streak_controller.dart';

class ShareDailyStreakBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShareDailyStreakController(
      title: Get.arguments['title'].toString().isEmpty ? 'Daily Goals Crushed!' : Get.arguments['title'],
      description: Get.arguments['description'].toString().isEmpty ? 'Another day, another streak' : Get.arguments['description'],
      imageUrl: Get.arguments['imageUrl'],
    ));
  }
}