import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';

class AppExceptionHandler {
  static AppException fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          type: AppExceptionType.timeout,
          message: "Koneksi timeout. Coba lagi nanti.",
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data['message'] ?? 'Terjadi kesalahan di server.';

        if (statusCode == 400) {
          return AppException(
            type: AppExceptionType.badRequest,
            message: message,
            statusCode: statusCode,
          );
        } else if (statusCode == 401) {
          return AppException(
            type: AppExceptionType.unauthorized,
            message: message,
            statusCode: statusCode,
          );
        } else if (statusCode == 404) {
          return AppException(
            type: AppExceptionType.notFound,
            message: "Data tidak ditemukan.",
            statusCode: statusCode,
          );
        } else if (statusCode == 500) {
          return AppException(
            type: AppExceptionType.serverError,
            message: "Server sedang bermasalah.",
            statusCode: statusCode,
          );
        } else {
          return AppException(
            type: AppExceptionType.unknown,
            message: message,
            statusCode: statusCode,
          );
        }

      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return AppException(
            type: AppExceptionType.noInternet,
            message: "Tidak ada koneksi internet.",
          );
        }

        return AppException(
          type: AppExceptionType.unknown,
          message: e.message ?? "Terjadi kesalahan yang tidak diketahui.",
        );

      default:
        return AppException(
          type: AppExceptionType.unknown,
          message: e.message ?? "Terjadi kesalahan.",
        );
    }
  }
}
