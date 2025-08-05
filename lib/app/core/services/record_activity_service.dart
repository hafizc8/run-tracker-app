import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/daily_record_model.dart';
import 'package:zest_mobile/app/core/models/model/record_activity_model.dart';
import 'package:zest_mobile/app/core/models/model/record_daily_mini_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class RecordActivityService {
  final ApiService _apiService;
  RecordActivityService(this._apiService);

  Future<dynamic> createSession({
    required double latitude,
    required double longitude,
    int stamina = 0
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.recordActivityCreateSession,
        method: HttpMethod.post,
        data: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          if (stamina != 0) 'stamina': stamina
        }
      );

      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }

  Future<RecordActivityModel> syncRecordActivity({
    required String recordActivityId,
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.recordActivitySyncRecord(recordActivityId),
        method: HttpMethod.post,
        data: data,
      );

      return RecordActivityModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<RecordActivityModel> endSession({
    required String recordActivityId
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.recordActivityEndSession(recordActivityId),
        method: HttpMethod.post,
      );

      return RecordActivityModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> syncDailyRecord({
    List<RecordDailyMiniModel>? records,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.dailyRecordSync,
        method: HttpMethod.post,
        data: {
          'data': records?.map((e) => e.toJson()).toList(),
        }
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedDataResponse<DailyRecordModel>> getDailyRecord({
    String? yearMonth, // YYYY-MM
    int page = 1,
    int? limit = 32,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.dailyRecordGetAll,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          if (limit != null) 'limit': limit.toString(),
          if (yearMonth != null) 'month': yearMonth,
        },
      );

      return PaginatedDataResponse<DailyRecordModel>.fromJson(
        response.data['data'],
        (json) => DailyRecordModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }
}