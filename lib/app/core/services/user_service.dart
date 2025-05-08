import 'package:dio/dio.dart';

import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/update_user_form.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';

class UserService {
  final ApiService _apiService;
  UserService(this._apiService);

  Future<bool> editUser(UpdateUserFormModel form) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.updateProfile,
        method: HttpMethod.post,
        headers: {'Content-Type': 'multipart/form-data'},
        data: await form.toFormData(),
      );
      if (response.statusCode == 200) {
        UserModel user = UserModel.fromJson(response.data['data']);
        await sl<StorageService>().write(StorageKeys.user, user.toJson());
      }

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<UserMiniModel>> getUserList({
    required int page,
    int random = 1,
    String search = '',
    String followStatus = 'followable',
  }) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.userOther,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          'random': random.toString(),
          'search': search,
          'follow_status': followStatus,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load user list');
      }

      return PaginatedDataResponse<UserMiniModel>.fromJson(
        response.data['data'],
        (json) => UserMiniModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }
}
