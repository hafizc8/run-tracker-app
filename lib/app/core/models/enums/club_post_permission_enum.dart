enum ClubPostPermissionEnum {
  onlyOwnerCanPost(0),
  participantsCanPost(1);

  final int value;
  const ClubPostPermissionEnum(this.value);

  static ClubPostPermissionEnum fromValue(int value) {
    return ClubPostPermissionEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ClubPostPermissionEnum.onlyOwnerCanPost,
    );
  }

  int get toValue => value;
}

extension ClubPostPermissionEnumExtension on ClubPostPermissionEnum {
  String get name {
    switch (this) {
      case ClubPostPermissionEnum.onlyOwnerCanPost:
        return 'Only club owner can post';
      case ClubPostPermissionEnum.participantsCanPost:
        return 'Participants can post';
    }
  }
}
