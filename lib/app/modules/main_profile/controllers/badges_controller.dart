import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/badge_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/badge_service.dart';

class BadgesController extends GetxController {
  var isLoading = false.obs;
  var badges = <BadgeModel>[].obs;

  final _badgeService = sl<BadgeService>();
  final _authService = sl<AuthService>();
  var userId = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['id'] != null) {
        userId = Get.arguments['id'];
      }
    }
    getBadges();
  }

  void getBadges() async {
    try {
      isLoading.value = true;
      badges.value = await _badgeService.getBadges(userId: userId);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
