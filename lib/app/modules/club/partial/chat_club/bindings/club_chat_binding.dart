import 'package:get/get.dart';

import '../controllers/club_chat_controller.dart';

class ClubChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubChatController>(() => ClubChatController());
  }
}
