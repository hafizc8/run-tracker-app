import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_post_form.dart';
import 'package:zest_mobile/app/core/models/model/post_all_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:dio/dio.dart';

class PostService {
  final ApiService _apiService;
  PostService(this._apiService);

  Future<PostAll> getAll() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.postGetAll,
        method: HttpMethod.get,
      );

      PostAll postAll = PostAll.fromJson(response.data['data']);
      return postAll;
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
