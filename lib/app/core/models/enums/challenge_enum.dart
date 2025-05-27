enum ChallengeTypeEnum {
  unknown(2),
  individual(0),
  team(1);

  final int value;
  const ChallengeTypeEnum(this.value);

  static ChallengeTypeEnum fromValue(int value) {
    return ChallengeTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ChallengeTypeEnum.unknown,
    );
  }

  int get toValue => value;
}

extension ChallengeTypeExtension on ChallengeTypeEnum {
  String get challengeType {
    switch (this) {
      case ChallengeTypeEnum.unknown:
        return 'Unknown';
      case ChallengeTypeEnum.individual:
        return 'Individual';
      case ChallengeTypeEnum.team:
        return 'Team';
    }
  }
}
