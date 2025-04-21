import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final _authService = sl<AuthService>();

  @override
  void onReady() {
    Get.offAllNamed(AppRoutes.login);
    // if (_authService.isAuthenticated) {
    //   Get.offAllNamed(AppRoutes.mainHome);
    // } else {
    //   Get.offAllNamed(AppRoutes.login);
    // }
    super.onReady();
  }
}
