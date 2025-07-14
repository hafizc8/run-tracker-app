import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/daily_streak/controllers/daily_streak_controller.dart';

class DailyStreakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyStreakController>(() => DailyStreakController());
  }
}