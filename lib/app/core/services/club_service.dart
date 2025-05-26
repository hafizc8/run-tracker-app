import 'package:dio/dio.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_club_form.dart';
import 'package:zest_mobile/app/core/models/forms/update_club_form.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/club_activities_model.dart';
import 'package:zest_mobile/app/core/models/model/club_member_model.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class ClubService {
  final ApiService _apiService;
  ClubService(this._apiService);

  Future<ClubModel> create(CreateClubFormModel form) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.clubCreate,
        method: HttpMethod.post,
        headers: {'Content-Type': 'multipart/form-data'},
        data: await form.toFormData(),
      );

      return ClubModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<ClubModel>> getAll({
    required int page,
    String search = '',
    int joined = 0,
    int random = 1,
    String joinStatus = '',
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.clubGetAll,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          'search': search,
          'joined': joined.toString(),
          'random': random.toString(),
          'join_status': joinStatus,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load club list');
      }

      return PaginatedDataResponse<ClubModel>.fromJson(
        response.data['data'],
        (json) => ClubModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> accOrJoinOrLeave({
    required String clubId,
    int leave = 0,
  }) async {
    try {
      Map<String, dynamic>? queryParams = {};

      if (leave == 1) {
        queryParams['leave'] = leave;
      }

      final response = await _apiService.request<FormData>(
        path: AppConstants.clubAccOrJoinOrLeave(clubId),
        method: HttpMethod.post,
        queryParams: queryParams,
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<ClubModel> getDetail({
    required String clubId,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.clubDetail(clubId),
        method: HttpMethod.get,
      );

      return ClubModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<ClubMemberModel>> getAllMembers({
    required String clubId,
    required int page,
    int? limit
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.clubGetAllMember(clubId),
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          if (limit != null) 'limit': limit.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load club list');
      }

      return PaginatedDataResponse<ClubMemberModel>.fromJson(
        response.data['data'],
        (json) => ClubMemberModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> inviteToClub({
    required String clubId,
    required List<String> userIds
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.clubInviteFollowersToClub(clubId),
        method: HttpMethod.post,
        data: {'user_ids': userIds},
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> update({
    required String clubId,
    required UpdateClubFormModel form
  }) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.clubUpdate(clubId),
        method: HttpMethod.post,
        headers: {'Content-Type': 'multipart/form-data'},
        data: await form.toFormData(),
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addOrRemoveAsAdmin({
    required String clubId,
    required String clubUserId,
    int? remove
  }) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.clubAddOrRemoveAsAdmin(clubId, clubUserId),
        method: HttpMethod.post,
        queryParams: {
          if (remove != null) 'remove': remove.toString(),
        }
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> removeUserInClub({
    required String clubId,
    required String clubUserId
  }) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.clubRemoveUserInClub(clubId, clubUserId),
        method: HttpMethod.delete
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<ClubActivitiesModel>> getClubActivity({
    required String clubId,
    required int page,
    int limit = 0,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.clubGetActivity(clubId),
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          if (limit != 0) 'limit': limit.toString(),
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load club list');
      }

      return PaginatedDataResponse<ClubActivitiesModel>.fromJson(
        response.data['data'],
        (json) => ClubActivitiesModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }
}
