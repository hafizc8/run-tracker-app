import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = sl<StorageService>().read(StorageKeys.token);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle Global Error di sini
    AppException appEx = AppExceptionHandler.fromDioError(err);
    switch (appEx.type) {
      case AppExceptionType.unauthorized:
        sl<StorageService>().remove(StorageKeys.token);
        sl<StorageService>().remove(StorageKeys.user);
        g.Get.offAllNamed(AppRoutes.login);
        break;
      case AppExceptionType.emailUnVerified:
        g.Get.offAllNamed(AppRoutes.registerVerifyEmail);
        break;
      case AppExceptionType.emptyProfile:
        g.Get.offAllNamed(AppRoutes.registerCreateProfile);
        break;
      case AppExceptionType.serverError:
        sl<StorageService>().remove(StorageKeys.token);
        sl<StorageService>().remove(StorageKeys.user);
        g.Get.offAllNamed(AppRoutes.login);
        break;
      default:
    }
    super.onError(err, handler);
  }
}
