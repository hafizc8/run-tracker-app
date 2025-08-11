import 'package:get/get.dart';

import '../controllers/share_daily_streak_controller.dart';

class ShareDailyStreakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareDailyStreakController>(
      () => ShareDailyStreakController(),
    );
  }
}