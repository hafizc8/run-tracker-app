import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';

import '../controllers/share_club_controller.dart';

class ShareClubBinding extends Bindings {
  @override
  void dependencies() {
    final clubModel = Get.arguments as ClubModel;
    Get.put(ShareClubController(clubModel: clubModel));
  }
}