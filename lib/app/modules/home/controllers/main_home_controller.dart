import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/modules/home/controllers/shop_controller.dart';
import 'package:zest_mobile/app/modules/home/views/home_view.dart';
import 'package:zest_mobile/app/modules/home/views/shop_view.dart';
import 'package:zest_mobile/app/modules/social/views/social_view.dart';
import 'package:zest_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/controllers/main_profile_controller.dart';
import 'package:zest_mobile/app/modules/main_profile/views/main_profile_view.dart';

class MainHomeController extends GetxController {
  MainHomeController() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ShopController>(() => ShopController());
    Get.lazyPut<ProfileMainController>(() => ProfileMainController());
  }

  final _authService = sl<AuthService>();

  var currentIndex = 0.obs;
  List<Widget> get pages => const [
        HomeView(),
        SocialView(),
        ShopView(),
        MainProfileView(),
      ];
  void changeTab(int index) {
    currentIndex.value = index;
    print('tab has changed to $index');
  }

  @override
  void onInit() {
    me();
    super.onInit();
  }

  Future<void> me() async {
    Get.context?.loaderOverlay.show();

    try {
      await _authService.me();
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      Get.context?.loaderOverlay.hide();
    }
  }
}
