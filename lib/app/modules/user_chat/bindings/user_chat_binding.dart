import 'package:get/get.dart';

import '../controllers/user_chat_controller.dart';

class UserChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserChatController>(() => UserChatController());
  }
}
