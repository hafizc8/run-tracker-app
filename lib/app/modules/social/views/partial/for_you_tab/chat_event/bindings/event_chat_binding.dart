import 'package:get/get.dart';

import '../controllers/event_chat_controller.dart';

class EventChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventChatController>(() => EventChatController());
  }
}
