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
  static const String user = "/me";
  static const String userOther = "/user";
  static const String updateProfile = "/user";

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
  static String event([String? id]) => id != null ? "/event/$id" : "/event";

  // Clubs
  static const String clubsMini = "/club";
  static const String clubGetAll = "/club";
  static const String clubCreate = "/club";
  static String clubAccOrJoinOrLeave(String clubdId) => "/club/$clubdId/join";
  static String clubDetail(String clubdId) => "/club/$clubdId";
  static String clubGetAllMember(String clubdId) => "/club/$clubdId/user";
}
