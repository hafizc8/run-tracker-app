import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/tab_bar_club_controller.dart';
import '../controllers/detail_club_controller.dart';

class DetailClubBinding extends Bindings {
  @override
  void dependencies() {
    final clubId = Get.arguments as String;
    Get.put(DetailClubController(clubId: clubId));

    Get.lazyPut<TabBarClubController>(
      () => TabBarClubController(),
      fenix: true,
    );
  }
}