import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:zest_mobile/app/core/dio/interceptor/app_interceptor.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl:
                kDebugMode ? AppConstants.baseUrlDev : AppConstants.baseUrl,
            headers: {'Accept': 'application/json'},
            connectTimeout: const Duration(seconds: 120),
            receiveTimeout: const Duration(seconds: 120),
            sendTimeout: const Duration(seconds: 120),
          ),
        ) {
    _dio.interceptors.addAll([
      AppInterceptor(),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        enabled: kDebugMode,
        maxWidth: 90,
      ),
    ]);
  }

  Dio get dio => _dio;
}
