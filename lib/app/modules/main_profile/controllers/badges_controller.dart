import 'package:get/get.dart';
import 'package:zest_mobile/app/app.dart';
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

  @override
  void onInit() {
    super.onInit();
    getBadges();
  }

  void getBadges() async {
    try {
      isLoading.value = true;
      badges.value =
          await _badgeService.getBadges(userId: _authService.user!.id!);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
