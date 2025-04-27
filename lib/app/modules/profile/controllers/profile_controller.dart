import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/modules/profile/widgets/custom_tab_bar/controllers/custom_tab_bar_controller.dart';

class ProfileController extends GetxController {
  ProfileController() {
    Get.lazyPut(() => TabBarController(), fenix: true);
  }

  final CarouselSliderController controllerSlider = CarouselSliderController();
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6'
  ];
  var activeIndex = 0.obs;

  final _authService = sl<AuthService>();

  UserModel? get user => _authService.user;
}
