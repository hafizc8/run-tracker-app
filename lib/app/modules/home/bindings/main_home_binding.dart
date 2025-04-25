import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/home/controllers/main_home_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';

class MainHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainHomeController>(MainHomeController());
    Get.lazyPut<SocialController>(() => SocialController());
  }
}
