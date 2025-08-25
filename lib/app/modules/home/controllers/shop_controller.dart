import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/shop_provider_model.dart';
import 'package:zest_mobile/app/core/services/shop_service.dart';

class ShopController extends GetxController {
  final _shopService = sl<ShopService>();

  var isLoading = false.obs;
  Rx<ShopProviderModel?> shopProviderModel = Rx(null);

  @override
  void onInit() {
    super.onInit();
    getShop();
  }

  Future<void> getShop() async {
    isLoading.value = true;
    try {
      shopProviderModel.value = await _shopService.getShop();
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openLink(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
