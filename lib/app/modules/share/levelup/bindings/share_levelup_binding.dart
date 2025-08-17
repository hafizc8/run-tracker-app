import 'package:get/get.dart';

import '../controllers/share_levelup_controller.dart';

class ShareLevelUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ShareLevelUpController(
        title: Get.arguments['title'],
        description: Get.arguments['description'],
        imageUrl: Get.arguments['imageUrl'],
      ),
    );
  }
}