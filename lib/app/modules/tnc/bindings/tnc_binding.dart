import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/tnc/controllers/tnc_controller.dart';

class TncBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TncController>(
      () => TncController(),
    );
  }
}
