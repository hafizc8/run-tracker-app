import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';

class MainHomeController extends GetxController {
  var isLoading = false.obs;

  final _authService = sl<AuthService>();

  @override
  void onInit() {
    me();
    super.onInit();
  }

  Future<void> me() async {
    isLoading.value = true;

    try {
      UserModel resp = await _authService.me();

      isLoading.value = false;
    } on AppException catch (e) {
      isLoading.value = false;

      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
