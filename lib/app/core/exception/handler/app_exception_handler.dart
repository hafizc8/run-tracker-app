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
        final data = e.response?.data;

        final message =
            e.response?.data['message'] ?? 'Terjadi kesalahan di server.';
        switch (statusCode) {
          case 400:
            return AppException(
              type: AppExceptionType.badRequest,
              message: message,
              statusCode: statusCode,
            );
          case 401:
            return AppException(
              type: AppExceptionType.unauthorized,
              message: 'Sesi anda telah habis. Silahkan login kembali.',
              statusCode: statusCode,
            );
          case 422:
            return AppException(
              type: AppExceptionType.validation,
              message: message,
              statusCode: statusCode,
              errors: Map<String, List<dynamic>>.from(data?['data'] ?? {}),
            );
          case 499:
            return AppException(
              type: AppExceptionType.emailUnVerified,
              message: message,
              statusCode: statusCode,
            );
          case 498:
            return AppException(
              type: AppExceptionType.emptyProfile,
              message: message,
              statusCode: statusCode,
            );
          case 404:
            return AppException(
              type: AppExceptionType.notFound,
              message: "Data tidak ditemukan.",
              statusCode: statusCode,
            );
          case 500:
            return AppException(
              type: AppExceptionType.serverError,
              message: "Server sedang bermasalah.",
              statusCode: statusCode,
            );
          default:
            return AppException(
              type: AppExceptionType.unknown,
              message: message,
              statusCode: statusCode,
            );
        }
      case DioExceptionType.connectionError:
        return AppException(
          type: AppExceptionType.noInternet,
          message: "Tidak ada koneksi internet.",
        );
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return AppException(
            type: AppExceptionType.noInternet,
            message: "Tidak ada koneksi internet.",
          );
        }

        return AppException(
          type: AppExceptionType.unknown,
          message: e.message ?? "Terjadi kesalahan dalam menghubungi server.",
        );

      default:
        return AppException(
          type: AppExceptionType.unknown,
          message: e.message ?? "Terjadi kesalahan.",
        );
    }
  }
}
