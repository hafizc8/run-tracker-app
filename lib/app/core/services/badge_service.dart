import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/badge_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class BadgeService {
  final ApiService _apiService;
  BadgeService(this._apiService);

  Future<List<BadgeModel>> getBadges({
    required String userId,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.badge(
          userId,
        ),
        method: HttpMethod.get,
      );

      return List.from(response.data['data'])
          .map<BadgeModel>((e) => BadgeModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
