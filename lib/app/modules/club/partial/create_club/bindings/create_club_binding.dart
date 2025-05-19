import 'package:get/get.dart';
import '../controllers/create_club_controller.dart';

class CreateClubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateClubController>(() => CreateClubController());
  }
}