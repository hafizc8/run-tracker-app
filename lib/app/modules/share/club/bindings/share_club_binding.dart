import 'package:get/get.dart';

import '../controllers/share_club_controller.dart';

class ShareClubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareClubController>(
      () => ShareClubController(),
    );
  }
}