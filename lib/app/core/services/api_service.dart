import 'package:dio/dio.dart';
import 'package:zest_mobile/app/core/dio/dio_client.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler.dart';
import 'package:zest_mobile/app/core/extension/http_method_extension.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  Future<Response> request<T>({
    required String path,
    required HttpMethod method,
    T? data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      switch (method) {
        case HttpMethod.get:
          return await _dioClient.dio.get(
            path,
            queryParameters: queryParams,
          );

        case HttpMethod.post:
        case HttpMethod.patch:
        case HttpMethod.put:
          if (data is FormData) {
            return await _dioClient.dio.request(
              path,
              data: data,
              options: Options(
                method: method.methodString,
                headers: headers,
              ),
              queryParameters: queryParams,
            );
          } else {
            return await _dioClient.dio.request(
              path,
              data: data,
              options: Options(
                method: method.methodString,
                headers: headers,
              ),
              queryParameters: queryParams,
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
