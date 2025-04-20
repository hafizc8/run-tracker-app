class AppConstants {
  const AppConstants._();

  // App related
  static const appName = "Zest Mobile";
  static const defaultLocale = "id_ID";
  static const googleApiKey = "AIzaSyD-ueM1nm0oVLA8c3ekfPu7rF2bD0NMD2w";

  // API
  static const API_VERSION = "v1";
  static const String baseUrlDev = "https://dev.zestplus.app/api/$API_VERSION";
  static const String baseUrl = "https://dev.zestplus.app/api/$API_VERSION";

  // Auth
  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";
  static const String forgotPassword = "/forgot-password";
  static const String resetPassword = "/reset-password";
  static const String completeProfile = "/complete-profile";
  static const String emailVerify = "/email/send";

  // User
  static const String user = "/user";
}
