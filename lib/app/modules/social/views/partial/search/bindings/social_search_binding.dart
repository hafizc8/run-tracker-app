import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/controllers/social_search_controller.dart';

class SocialSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SocialSearchController>(
      () => SocialSearchController(),
      fenix: true,
    );
  }
}
