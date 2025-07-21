import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_challenge_form.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class ChallengeService {
  final ApiService _apiService;
  ChallengeService(this._apiService);

  Future<PaginatedDataResponse<ChallengeModel>> getChallenges({
    int page = 1,
    int? random,
    int limit = 20,
    String? search,
    String? status,
  }) async {
    try {
      final response = await _apiService.request(
          path: AppConstants.challenge(),
          method: HttpMethod.get,
          queryParams: {
            'page': page.toString(),
            if (random != null) 'random': random.toString(),
            if (limit != 20) 'limit': limit.toString(),
            if (search != null) 'search': search,
            if (status != null) 'join_status': status,
          });

      return PaginatedDataResponse<ChallengeModel>.fromJson(
        response.data['data'],
        (json) => ChallengeModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> storeChallenge(CreateChallengeFormModel form) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.challenge(),
        method: HttpMethod.post,
        data: form.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create challenge');
      }

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<ChallengeDetailModel?> detailChallenge(String id) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.challenge(id: id),
        method: HttpMethod.get,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load challenge detail');
      }

      return ChallengeDetailModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
