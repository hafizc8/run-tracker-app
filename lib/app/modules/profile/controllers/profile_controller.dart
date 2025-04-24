import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/modules/profile/controllers/settings_controller.dart';

class ProfileController extends GetxController {
  ProfileController() {
    Get.lazyPut(() => SettingsController(), fenix: true);
  }

  final _authService = sl<AuthService>();

  UserModel? get user => _authService.user;
}
