extension FollowStatusExtension on Map<String, int> {
  String get followStatus {
    final isFollowing = this['is_following'] ?? 0;
    final isFollowed = this['is_followed'] ?? 0;

    if (isFollowing == 1 && isFollowed == 1) {
      return 'Message';
    } else if (isFollowing == 1) {
      return 'Following';
    } else if (isFollowed == 1) {
      return 'Folback';
    } else {
      return 'Follow';
    }
  }

  String get followingStatus {
    final isFollowing = this['is_followed'] ?? 0;
    if (isFollowing == 1) {
      return 'Message';
    } else {
      return 'Follow';
    }
  }
}
