import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';

class ProfileController extends GetxController {
  var activeIndex = 0.obs;

  final _authService = sl<AuthService>();

  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = _authService.user;
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
}
