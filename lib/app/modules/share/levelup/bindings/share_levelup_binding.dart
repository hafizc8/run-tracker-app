import 'package:get/get.dart';

import '../controllers/share_levelup_controller.dart';

class ShareLevelUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ShareLevelUpController(
        title: Get.arguments['title'].toString().isEmpty ? 'Level Up!' : Get.arguments['title'],
        description: Get.arguments['description'].toString().isEmpty ? 'Who\'s leveling up next?' : Get.arguments['description'],
        imageUrl: Get.arguments['imageUrl'],
      ),
    );
  }
}