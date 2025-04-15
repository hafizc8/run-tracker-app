import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/src/pretty_dio_logger.dart';
import 'package:zest_mobile/app/core/dio/interceptor/app_interceptor.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl:
                kDebugMode ? AppConstants.baseUrlDev : AppConstants.baseUrl,
            headers: {'Content-Type': 'application/json'},
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
          ),
        ) {
    _dio.interceptors.addAll([
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
      AppInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}
