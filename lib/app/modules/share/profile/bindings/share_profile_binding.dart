import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';

import '../controllers/share_profile_controller.dart';

class ShareProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments is UserDetailModel) {
      final userDetailModel = Get.arguments as UserDetailModel;
      Get.put(ShareProfileController(userDetailModel: userDetailModel));
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