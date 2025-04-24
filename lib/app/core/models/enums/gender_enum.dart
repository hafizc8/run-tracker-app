enum GenderEnum {
  unknown(0),
  male(1),
  female(2);

  final int value;
  const GenderEnum(this.value);

  static GenderEnum fromValue(int value) {
    return GenderEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GenderEnum.unknown,
    );
  }

  int get toValue => value;
}

extension GenderEnumExtension on GenderEnum {
  String get name {
    switch (this) {
      case GenderEnum.unknown:
        return 'Prefer not to say';
      case GenderEnum.male:
        return 'Male';
      case GenderEnum.female:
        return 'Female';
    }
  }
}
