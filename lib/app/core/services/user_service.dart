import 'package:dio/dio.dart';

import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/update_user_form.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/models/model/stamina_requirement_model.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
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

  Future<UserDetailModel> detailUser(String id) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.user(id),
        method: HttpMethod.get,
      );

      return UserDetailModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> followUser(String id) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.userFollow(id),
        method: HttpMethod.post,
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unFollowUser(String id) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.userUnFollow(id),
        method: HttpMethod.post,
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<UserMiniModel>> getUserList({
    required int page,
    int random = 1,
    String search = '',
    String? followStatus,
    String? followingBy,
    String? followersBy,
    String? checkClub,
  }) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.userOther,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          'random': random.toString(),
          'search': search,
          if (followingBy != null) 'following_by': followingBy,
          if (followersBy != null) 'follower_by': followersBy,
          if (followStatus != null) 'follow_status': followStatus,
          if (checkClub != null) 'check_club': checkClub,
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

  Future<bool> updateUserPreference({
    int? unit, // 0 km, 1 miles
    bool? allowNotification,
    bool? allowEmailNotification,
    int? dailyStepGoals,
  }) async {
    try {
      final response = await _apiService.request(
          path: AppConstants.updateUserPreference,
          method: HttpMethod.patch,
          data: {
            '_method': 'patch',
            if (unit != null) 'unit': unit,
            if (allowNotification != null)
              'allow_notification': allowNotification,
            if (allowEmailNotification != null)
              'allow_email_notification': allowEmailNotification,
            if (dailyStepGoals != null) 'daily_step_goals': dailyStepGoals
          });

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<HomePageDataModel> loadHomePageData() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.homePageData,
        method: HttpMethod.get,
      );

      return HomePageDataModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StaminaRequirementModel>> loadStaminaRequirement() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.staminaRequirement,
        method: HttpMethod.get,
      );

      return response.data['data'].map<StaminaRequirementModel>((e) => StaminaRequirementModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readPopupNotification({
    List<String>? ids,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.readPopupNotification,
        method: HttpMethod.put,
        data: {
          if (ids != null) 'ids': ids,
        }
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }
}
