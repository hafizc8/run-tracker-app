extension EventExtension on int {
  String get toEventStatus {
    switch (this) {
      case 0:
        return 'Join';
      case 1:
        return 'Joined';
      default:
        return 'Join';
    }
  }
}
