import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/app_link_service.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final _authService = sl<AuthService>();
  final _appLinkService = sl<AppLinkService>();

  @override
  void onReady() {
    super.onReady();
    redirect();
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(milliseconds: 1000)); // opsional smooth

    if (_appLinkService.initialUri != null) {
      print("App opened via deep link. SplashController will not navigate.");
      return; 
    }
    
    if (_authService.isAuthenticated) {
      Get.offAllNamed(AppRoutes.mainHome);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
