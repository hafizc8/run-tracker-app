abstract class AppRoutes {
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
  static const registerVerifyEmail = '/register-verify-email';
  static const registerVerifyEmailSuccess = '/register-verify-email-success';
}
