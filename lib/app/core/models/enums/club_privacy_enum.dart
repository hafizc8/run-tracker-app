enum ClubPrivacyEnum {
  public(0),
  private(1);

  final int value;
  const ClubPrivacyEnum(this.value);

  static ClubPrivacyEnum fromValue(int value) {
    return ClubPrivacyEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ClubPrivacyEnum.public,
    );
  }

  int get toValue => value;
}

extension ClubPrivacyEnumExtension on ClubPrivacyEnum {
  String get name {
    switch (this) {
      case ClubPrivacyEnum.public:
        return 'Open to public';
      case ClubPrivacyEnum.private:
        return 'Private';
    }
  }
}
