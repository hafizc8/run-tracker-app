abstract class AppRoutes {
  static const splash = '/splash';

  static const mainHome = '/home/main-home';
  static const home = '/home';

  // Auth group
  static const login = '/auth/login';

  // Forgot Password flow
  static const forgotPassword = '/auth/forgot-password';
  static const forgotPasswordEmailSent = '/auth/forgot-password/email-sent';
  static const forgotPasswordSetNew = '/auth/forgot-password/set-new-password';
  static const forgotPasswordUpdated = '/auth/forgot-password/password-updated';

  // Register flow
  static const register = '/auth/register';
  static const registerSuccess = '/auth/register/success';
  static const registerVerifyEmail = '/auth/register-verify-email';
  static const registerVerifyEmailSuccess = '/auth/register-verify-email-success';
  static const registerCreateProfile = '/auth/register-create-profile';

  static const registerCreateProfileChooseLocation = '/auth/register-create-profile-choose-location';

  static const social = '/social';
  static const socialYourPageActivityDetail = '/social/your-page/activity-detail';

  // profile
  static const profile = '/profile';
  static const settings = '/settings';
  static const activity = '/activity';
  static const badges = '/badges';
}
