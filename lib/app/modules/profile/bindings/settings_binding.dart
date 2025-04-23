import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/profile/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
