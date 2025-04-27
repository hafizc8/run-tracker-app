import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/profile/controllers/profile_controller.dart';

class TabBarController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final ProfileController profileController = Get.find();

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
