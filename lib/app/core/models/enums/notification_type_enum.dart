/// welcome-registered-user
/// user-levelling-up
/// user-following
/// club-invite
/// challange-invite
/// event-invite
/// post-comment
/// post-like
enum NotificationTypeEnum {
  welcomeRegisteredUser,
  userLevellingUp,
  userFollowing,
  clubInvite,
  challangeInvite,
  eventInvite,
  postComment,
  postLike
}

extension NotificationTypeEnumExtension on NotificationTypeEnum {
  String get name {
    switch (this) {
      case NotificationTypeEnum.welcomeRegisteredUser:
        return 'welcome-registered-user';
      case NotificationTypeEnum.userLevellingUp:
        return 'user-levelling-up';
      case NotificationTypeEnum.userFollowing:
        return 'user-following';
      case NotificationTypeEnum.clubInvite:
        return 'club-invite';
      case NotificationTypeEnum.challangeInvite:
        return 'challange-invite';
      case NotificationTypeEnum.eventInvite:
        return 'event-invite';
      case NotificationTypeEnum.postComment:
        return 'post-comment';
      case NotificationTypeEnum.postLike:
        return 'post-like';
    }
  }
}