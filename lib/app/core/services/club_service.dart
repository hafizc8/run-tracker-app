import 'package:dio/dio.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_club_form.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class ClubService {
  final ApiService _apiService;
  ClubService(this._apiService);

  Future<bool> create(CreateClubFormModel form) async {
    try {
      final response = await _apiService.request<FormData>(
        path: AppConstants.clubCreate,
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
