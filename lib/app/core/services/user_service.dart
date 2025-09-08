import 'package:dio/dio.dart';

import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/update_user_form.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/chat_inbox_model.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';
import 'package:zest_mobile/app/core/models/model/notification_model.dart';
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

  Future<PaginatedDataResponse<ChatModel>> getChats({
    required String userId,
    int page = 1,
    DateTime? date,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.userChat(userId),
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          if (date != null) 'start_datetime': date.toString(),
        },
      );

      return PaginatedDataResponse<ChatModel>.fromJson(
        response.data['data'],
        (json) => ChatModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<ChatInboxModel>> getInboxChats({
    int page = 1,
    String? relatedType,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.inboxChat(),
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          if (relatedType != null) 'relateable_type': relatedType,
        },
      );

      return PaginatedDataResponse<ChatInboxModel>.fromJson(
        response.data['data'],
        (json) => ChatInboxModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel?> storeChat({
    required String userId,
    required String message,
  }) async {
    try {
      final response = await _apiService.request(
          path: AppConstants.userChat(userId),
          method: HttpMethod.post,
          data: {
            'message': message,
          });

      if (response.statusCode != 200) {
        throw Exception('Failed to store chat user');
      }

      return ChatModel.fromJson(response.data['data']);
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

      UserDetailModel user = UserDetailModel.fromJson(response.data['data']);

      return user;
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

  Future<bool> deleteAccount() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.userOther,
        method: HttpMethod.delete,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete account');
      }

      if (response.data['success']) {
        await sl<StorageService>().remove(StorageKeys.token);
        await sl<StorageService>().remove(StorageKeys.user);
        await sl<StorageService>().remove(StorageKeys.detailUser);
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
    String? followStatus,
    String? followingBy,
    String? followersBy,
    String? checkClub,
    String? checkChallenge,
  }) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.userOther,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          'random': random.toString(),
          if (checkChallenge != null) 'check_challange': checkChallenge,
          if (search != '') 'search': search,
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

      return response.data['data']
          .map<StaminaRequirementModel>(
              (e) => StaminaRequirementModel.fromJson(e))
          .toList();
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
          });

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<NotificationModel>> getNotification({
    required int page,
    int limit = 15,
  }) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.notification,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load notification list');
      }

      return PaginatedDataResponse<NotificationModel>.fromJson(
        response.data['data'],
        (json) => NotificationModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readNotification({String? notificationId}) async {
    try {
      final response = await _apiService.request(
          path: AppConstants.notificationRead,
          method: HttpMethod.put,
          queryParams: {if (notificationId != null) 'id': notificationId});

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }
}
