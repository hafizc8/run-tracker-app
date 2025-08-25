import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/all_badges/controllers/all_badges_controller.dart';

class AllBadgesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllBadgesController>(() => AllBadgesController());
  }
}