class AppConstants {
  const AppConstants._();

  // App related
  static const appName = "Zest Mobile";
  static const defaultLocale = "id_ID";

  // API
  static const API_VERSION = "v1";
  static const String baseUrlDev = "https://dev.zestplus.app/api/$API_VERSION";
  static const String baseUrl = "https://dev.zestplus.app/api/$API_VERSION";

  // Auth
  static const String login = "/login";
  static const String register = "/register";
  static const String logout = "/logout";
  static const String emailVerify = "/email/send";

  // User
  static const String user = "/user";
}
