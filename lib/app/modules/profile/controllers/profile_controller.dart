import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/profile/controllers/settings_controller.dart';

class ProfileController extends GetxController {
  ProfileController() {
    Get.lazyPut(() => SettingsController());
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
