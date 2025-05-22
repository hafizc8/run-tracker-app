import 'package:get/get.dart';
import '../controllers/preview_club_controller.dart';

class PreviewClubBinding extends Bindings {
  @override
  void dependencies() {
    final clubId = Get.arguments as String;
    Get.put(PreviewClubController(clubId: clubId));
  }
}