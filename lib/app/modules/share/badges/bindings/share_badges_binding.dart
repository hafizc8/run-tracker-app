import 'package:get/get.dart';
import '../controllers/share_badges_controller.dart';

class ShareBadgesBinding extends Bindings {
  @override
  void dependencies() {
    final title = Get.arguments['title'].toString().isEmpty ? 'Just Earned This Achievement Today!' : Get.arguments['title'];
    final description = Get.arguments['description'].toString().isEmpty ? 'Your turn to flex this badge' : Get.arguments['description'];
    final imageUrl = Get.arguments['imageUrl'];

    Get.put(ShareBadgesController(
      title: title, 
      description: description, 
      imageUrl: imageUrl,
    ));
  }
}