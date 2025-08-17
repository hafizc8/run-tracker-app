import 'package:get/get.dart';
import '../controllers/share_badges_controller.dart';

class ShareBadgesBinding extends Bindings {
  @override
  void dependencies() {
    final title = Get.arguments['title'];
    final description = Get.arguments['description'];
    final imageUrl = Get.arguments['imageUrl'];

    Get.put(ShareBadgesController(
      title: title, 
      description: description, 
      imageUrl: imageUrl,
    ));
  }
}