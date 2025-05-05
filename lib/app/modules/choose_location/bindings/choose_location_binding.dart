import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/choose_location/controllers/choose_location_controller.dart';

class ChooseLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseLocationController>(
      () => ChooseLocationController(),
      fenix: true,
    );
  }
}
