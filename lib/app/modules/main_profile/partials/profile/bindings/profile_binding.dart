import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments is String) {
      final userId = Get.arguments as String;
      Get.put(ProfileController(userId: userId));
    } else {
      Future.delayed(Duration.zero, () {
        Get.snackbar("Error", "Could not load data");
        if (Get.previousRoute.isNotEmpty) {
          Get.back(closeOverlays: true);
        }
      });
    }
  }
}
