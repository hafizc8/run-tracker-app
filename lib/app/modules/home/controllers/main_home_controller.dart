import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MainHomeController extends GetxController {
  final _authService = sl<AuthService>();

  var currentIndex = 0.obs;
  List<Widget> get pages => [
        SafeArea(child: Center(child: Text('Home'))),
        SafeArea(child: Center(child: Text('Social'))),
        SafeArea(child: Center(child: Text('Shop'))),
        SafeArea(child: Center(child: Text('Profile'))),
      ];
  void changeTab(int index) {
    currentIndex.value = index;
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
      Get.context?.loaderOverlay.hide();
    } on AppException catch (e) {
      Get.context?.loaderOverlay.hide();
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.context?.loaderOverlay.hide();
      Get.snackbar('Error', e.toString());
    }
  }
}
