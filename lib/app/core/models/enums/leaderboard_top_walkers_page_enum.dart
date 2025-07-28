enum LeaderboardTopWalkersPageEnum {
  global,
  country,
  province,
  regency,
  district
}

// get value
extension LeaderboardTopWalkersPageEnumExtension on LeaderboardTopWalkersPageEnum {
  String get value {
    switch (this) {
      case LeaderboardTopWalkersPageEnum.global:
        return 'global';
      case LeaderboardTopWalkersPageEnum.country:
        return 'country';
      case LeaderboardTopWalkersPageEnum.province:
        return 'province';
      case LeaderboardTopWalkersPageEnum.regency:
        return 'district';
      case LeaderboardTopWalkersPageEnum.district:
        return 'subdistrict';
    }
  }
}