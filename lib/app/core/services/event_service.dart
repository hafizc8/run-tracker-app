import 'package:dio/dio.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/store_event_form.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/club_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/event_activity_model.dart';
import 'package:zest_mobile/app/core/models/model/event_location_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class EventService {
  final ApiService _apiService;
  EventService(this._apiService);

  Future<List<EventActivityModel>> getEventActivity() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.eventActivity,
        method: HttpMethod.get,
      );

      return List.from(response.data['data'])
          .map<EventActivityModel>((e) => EventActivityModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ClubMiniModel>> getEventClubs() async {
    try {
      final response = await _apiService.request(
          path: AppConstants.clubsMini,
          method: HttpMethod.get,
          queryParams: {
            "join_status": 'joined',
            'limit': '9999',
            'compact': '1',
          });

      return List.from(response.data['data']['data'])
          .map<ClubMiniModel>((e) => ClubMiniModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<EventLocationModel>> getEventLocation() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.eventLocation,
        method: HttpMethod.get,
      );

      return List.from(response.data['data'])
          .map<EventLocationModel>((e) => EventLocationModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel?> cancelEvent(String id) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.eventDetail(id),
        method: HttpMethod.delete,
      );

      return EventModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel?> detailEvent(String id) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.eventDetail(id),
        method: HttpMethod.get,
      );

      return EventModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> accLeaveJoinEvent(String id, {String? leave}) async {
    try {
      final response = await _apiService.request(
          path: AppConstants.eventAccLeaveJoin(id),
          method: HttpMethod.post,
          queryParams: {
            if (leave != null) 'leave': leave,
          });

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> inviteOrReserveEvent(String id,
      {bool? isReserved = false, List<String> userIds = const []}) async {
    try {
      final response = await _apiService.request(
          path: AppConstants.eventInviteFriend(id),
          method: HttpMethod.post,
          data: {
            'is_reserved': isReserved,
            'user_ids': userIds,
          });

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<EventModel>> getEvents({
    int page = 1,
    int random = 1,
    String? activity,
    String? location,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.event(),
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          if (activity != null) 'activity': activity,
          if (location != null) 'location': location,
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
          'random': random.toString(),
        },
      );

      return PaginatedDataResponse<EventModel>.fromJson(
        response.data['data'],
        (json) => EventModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<EventUserModel>> getEventUsers({
    required String eventId,
    int page = 1,
    List<String> statues = const [],
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.eventUsers(eventId),
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          for (var status in statues) 'status[]': status,
        },
      );

      return PaginatedDataResponse<EventUserModel>.fromJson(
        response.data['data'],
        (json) => EventUserModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel?> storeEvent(EventStoreFormModel form) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.event(),
        method: HttpMethod.post,
        data: await form.toFormData(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to store event');
      }

      return EventModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel?> updateEvent(EventStoreFormModel form,
      [String? id]) async {
    try {
      FormData formData = await form.toFormData();
      formData.fields.add(const MapEntry('_method', 'put'));
      final response = await _apiService.request<FormData>(
        path: AppConstants.event(id),
        method: HttpMethod.post,
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to store event');
      }

      return EventModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
