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
  static const String user = "/user";
  static const String updateProfile = "/user";
}
