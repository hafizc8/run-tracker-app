import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  const AppConstants._();

  // App related
  static const appName = "Zest Mobile";
  static const defaultLocale = "id_ID";
  static const googleApiKey = "AIzaSyD-ueM1nm0oVLA8c3ekfPu7rF2bD0NMD2w";

  // API
  static const apiVersion = "v1";
  static const String baseUrlDev = "https://dev.zestplus.app/api/$apiVersion";
  static const String baseUrl = "https://dev.zestplus.app/api/$apiVersion";

  // Link Share
  static const String baseUrlShareLink = "https://dev.zestplus.app/link";

  // Auth
  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";
  static const String forgotPassword = "/forgot-password";
  static const String resetPassword = "/reset-password";
  static const String completeProfile = "/complete-profile";
  static const String emailVerify = "/email/send";
  static String searchLocation(String query) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${AppConstants.googleApiKey}&components=country:ID';

  static String addressFromLatLang(LatLng latLng) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${AppConstants.googleApiKey}';

  static String selectPlace(String placeId) =>
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${AppConstants.googleApiKey}';
  // User
  static const String me = "/me";
  static const String userOther = "/user";
  static const String updateProfile = "/user";
  static const String updateUserPreference = "/user/preference";
  static String badge(String id) => "/user/$id/badge";
  static String user(String id) => "/user/$id";
  static String follow(String id) => "/follow/$id";
  static String userFollow(String id) => "/follow/$id";
  static String userUnFollow(String id) => "/unfollow/$id";

  // Post
  static const String postGetAll = "/post";
  static const String postCreate = "/post";
  static String postDetail(String postId) => "/post/$postId";
  static String postLikeDislike(String postId) => "/post/$postId/like";
  static String postCommentReply(String postId) => "/post/$postId/comment";
  static String postDelete(String postId) => "/post/$postId";
  static String postUpdate(String postId) => "/post/$postId";

  // Event
  static const String eventActivity = "/event/activity";
  static const String eventLocation = "/event/location";
  static String eventDetail(String id) => "/event/$id";
  static String eventAccLeaveJoin(String id) => "/event/$id/join";
  static String eventInviteFriend(String id) => "/event/$id/invite";
  static String eventUsers(String id) => "/event/$id/user";
  static String event([String? id]) => id != null ? "/event/$id" : "/event";

  // Challenge
  static String challenge({String? id}) =>
      id != null ? "/challange/$id" : "/challange";

  static String challengeCancel({String? id}) => "/challange/$id/cancel";
  static String challengeUser({String? id}) => "/challange/$id/user";
  static String challengeInviteFriend({String? id}) => "/challange/$id/invite";
  static String challengeJoin({String? id}) => "/challange/$id/join";

  // Clubs
  static const String clubsMini = "/club";
  static const String clubGetAll = "/club";
  static const String clubCreate = "/club";
  static String clubUpdate(String clubId) => "/club/$clubId";
  static String clubAccOrJoinOrLeave(String clubId) => "/club/$clubId/join";
  static String clubAddOrRemoveAsAdmin(String clubId, String clubUserId) =>
      "/club/$clubId/user/$clubUserId/admin";
  static String clubRemoveUserInClub(String clubId, String clubUserId) =>
      "/club/$clubId/user/$clubUserId";
  static String clubDetail(String clubId) => "/club/$clubId";
  static String clubGetAllMember(String clubId) => "/club/$clubId/user";
  static String clubInviteFollowersToClub(String clubId) =>
      "/club/$clubId/invite";
  static String clubGetActivity(String clubId) => "/club/$clubId/activity";

  // Record Activity
  static const String recordActivityCreateSession = "/record-activity/create";
  static String recordActivitySyncRecord(String recordActivityId) =>
      "/record-activity/$recordActivityId/sync";
  static String recordActivityEndSession(String recordActivityId) =>
      "/record-activity/$recordActivityId/end";

  static const String dailyRecordSync = "/record-daily";
  static const String dailyRecordGetAll = "/record-daily";

  static const String homePageData = "/home";
  static const String staminaRequirement =
      "/record-activity/stamina-requirement";

  // leaderboard
  static const String leaderboard = "/leaderboard";

  // popup-notification
  static const String readPopupNotification = "/popup-notification";




  // Share Link
  static String shareProfileLink(String id) => "$baseUrlShareLink/share-profile?user=$id";
  static String shareClubLink(String id) => "$baseUrlShareLink/share-club?club=$id";
  static String shareEventLink(String id) => "$baseUrlShareLink/share-event?event=$id";
}
