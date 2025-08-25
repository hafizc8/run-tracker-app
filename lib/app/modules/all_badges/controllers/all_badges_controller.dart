import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/badge_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/badge_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:zest_mobile/app/modules/home/widgets/set_daily_goals_dialog.dart';

class AllBadgesController extends GetxController {
  
  final _badgeService = sl<BadgeService>();
  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  
  RxBool isLoadingBadges = false.obs;

  var allBadges = <BadgeModel>[].obs;
  var myBadges = <BadgeModel>[].obs;
  RxList<List<BadgeModel>> allCategorizedBadges = <List<BadgeModel>>[].obs;

  UserModel? get user => _authService.user;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getBadges();
  }

  @override

  void onReady() {
    super.onReady();
  }

  void getBadges() async {
    try {
      isLoadingBadges.value = true;

      myBadges.value = await _badgeService.getBadges(userId: _authService.user!.id!);
      allBadges.value = await _badgeService.getAllBadges();

      // update allBadges, if badgeKey is in myBadges, set isLocked: false
      allBadges.value = allBadges.map((badge) {
        if (myBadges.any((myBadge) => myBadge.badgeKey == badge.badgeKey)) {
          return badge.copyWith(isLocked: false);
        }
        return badge;
      }).toList();

      // categorize by category
      final categorizedBadges = <String, List<BadgeModel>>{};
      for (final badge in allBadges) {
        categorizedBadges
            .putIfAbsent(badge.category!, () => <BadgeModel>[])
            .add(badge);
      }
      allCategorizedBadges.value = categorizedBadges.values.toList();

    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingBadges.value = false;
    }
  }

  Future<void> showDailyGoalDialog() async {
    Get.dialog(
      SetDailyGoalDialog(
        onSave: (selectedGoal) async {
          try {
            // Di sini Anda panggil API untuk menyimpan goal
            var response = await _userService.updateUserPreference(dailyStepGoals: selectedGoal);

            if (response) {
              Get.back();
              Get.snackbar('Success', 'Your daily goal has been set to $selectedGoal steps!');

              // find HomeController
              Get.find<HomeController>().refreshData();
            }
          } catch (e) {
            print('Failed to save goal: $e');
            Get.snackbar('Error', 'Failed to save your daily goal.');
          }
        },
        isChangeDailyGoals: true,
        initialCurrentDailyGoals: user?.userPreference?.dailyStepGoals ?? 0,
      ),
      barrierDismissible: true,
    );
  }
}