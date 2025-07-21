import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_response_model.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class LeaderboardService {
  final ApiService _apiService;
  LeaderboardService(this._apiService);

  Future<LeaderboardResponseModel> getLeaderboard({
    required int page,
    int? limit,
    String? locationLevel,
    bool? friendOnly,
    String? clubId,
  }) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.leaderboard,
        method: HttpMethod.get,
        queryParams: {
          'page': page.toString(),
          if (limit != null) 'limit': limit.toString(),
          if (locationLevel != null) 'location_level': locationLevel,
          if (friendOnly != null) 'friend_only': (friendOnly ? 1 : 0).toString(),
          if (clubId != null) 'club_id': clubId,
        },
      );

      final responseData = response.data['data'];

      // Parse data 'me'
      final meData = responseData['me'] != null
          ? LeaderboardUserModel.fromJson(responseData['me'])
          : null;

      // Parse data 'leaderboards' yang terpaginasi
      final leaderboardsData = responseData['leaderboards'] != null
          ? PaginatedDataResponse<LeaderboardUserModel>.fromJson(
              responseData['leaderboards'],
              (json) => LeaderboardUserModel.fromJson(json),
            )
          : null;

      return LeaderboardResponseModel(
        me: meData,
        leaderboards: leaderboardsData,
      );
    } catch (e) {
      rethrow;
    }
  }
}