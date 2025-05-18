import 'package:get/get.dart';
import '../controllers/detail_club_controller.dart';

class DetailClubBinding extends Bindings {
  @override
  void dependencies() {
    final clubId = Get.arguments as String;
    Get.put(DetailClubController(clubId: clubId));
  }
}