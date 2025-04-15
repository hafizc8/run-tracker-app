import 'package:dio/dio.dart';
import 'package:zest_mobile/app/core/dio/dio_client.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler.dart';
import 'package:zest_mobile/app/core/extension/http_method_extension.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'dart:io';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  Future<Response> request({
    required String path,
    required HttpMethod method,
    dynamic data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    File? file,
  }) async {
    try {
      switch (method) {
        case HttpMethod.get:
          return await _dioClient.dio.get(
            path,
            queryParameters: queryParams,
          );

        case HttpMethod.post:
        case HttpMethod.put:
          FormData formData;

          if (file != null) {
            formData = FormData.fromMap({
              "file": await MultipartFile.fromFile(file.path,
                  filename: file.uri.pathSegments.last),
              "data": data,
            });
            return await _dioClient.dio.request(
              path,
              data: formData,
              options: Options(
                method: method.methodString,
                headers: headers,
              ),
            );
          } else {
            return await _dioClient.dio.request(
              path,
              data: data,
              options: Options(
                method: method.methodString,
                headers: headers,
              ),
            );
          }

        case HttpMethod.delete:
          return await _dioClient.dio.delete(
            path,
            queryParameters: queryParams,
          );

        default:
          throw Exception("Unsupported HTTP method.");
      }
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioError(e);
    } catch (e) {
      throw AppException(
        type: AppExceptionType.unknown,
        message: "Kesalahan tidak diketahui.",
      );
    }
  }
}
