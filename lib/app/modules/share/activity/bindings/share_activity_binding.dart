import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';

import '../controllers/share_activity_controller.dart';

class ShareActivityBinding extends Bindings {
  @override
  void dependencies() {
    final postModel = Get.arguments as PostModel;
    Get.put(ShareActivityController(postModel: postModel));
  }
}