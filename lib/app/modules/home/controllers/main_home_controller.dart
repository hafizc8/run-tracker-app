import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/modules/social/views/social_view.dart';

class MainHomeController extends GetxController {
  final _authService = sl<AuthService>();

  var currentIndex = 0.obs;
  List<Widget> get pages => [
        const SafeArea(child: Center(child: Text('Home'))),
        SocialView(),
        const SafeArea(child: Center(child: Text('Shop'))),
        const SafeArea(child: Center(child: Text('Profile'))),
      ];
  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    // me();
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
