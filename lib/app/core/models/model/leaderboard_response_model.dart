import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';

class LeaderboardResponseModel extends Model<LeaderboardResponseModel> {
  final LeaderboardUserModel? me;
  final PaginatedDataResponse<LeaderboardUserModel>? leaderboards;

  LeaderboardResponseModel({
    this.me,
    this.leaderboards,
  });

  @override
  LeaderboardResponseModel copyWith({
    LeaderboardUserModel? me,
    PaginatedDataResponse<LeaderboardUserModel>? leaderboards,
  }) {
    return LeaderboardResponseModel(
      me: me ?? this.me,
      leaderboards: leaderboards ?? this.leaderboards,
    );
  }

  // fromJson dan toJson tidak diperlukan jika model ini hanya untuk return
  // dari service, tetapi bisa ditambahkan jika perlu.

  @override
  List<Object?> get props => [me, leaderboards];
  
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}