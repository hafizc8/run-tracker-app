import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_post_form.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:dio/dio.dart';

class PostService {
  final ApiService _apiService;
  PostService(this._apiService);

  Future<PaginatedDataResponse<PostModel>> getAll({
    required int page
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.postGetAll,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load post list');
      }

      return PaginatedDataResponse<PostModel>.fromJson(
        response.data['data'],
        (json) => PostModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> create(CreatePostFormModel form) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.postCreate,
        method: HttpMethod.post,
        headers: {'Content-Type': 'multipart/form-data'},
        data: await form.toFormData(),
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }
}
