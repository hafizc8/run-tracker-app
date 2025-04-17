import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RegisterVerifyEmailSuccessController extends GetxController {
  final AuthService _authService = sl<AuthService>();

  @override
  void onInit() async {
    await Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAllNamed(AppRoutes.registerCreateProfile),
    );
    super.onInit();
  }
}
