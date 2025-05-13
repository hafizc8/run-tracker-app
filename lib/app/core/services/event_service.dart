import 'package:dio/dio.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/store_event_form.dart';
import 'package:zest_mobile/app/core/models/model/event_activity_model.dart';
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

  Future<bool> storeEvent(EventStoreFormModel form) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.eventStore,
        method: HttpMethod.post,
        data: await form.toFormData(),
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }
}
