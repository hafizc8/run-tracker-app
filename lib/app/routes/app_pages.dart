import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import 'package:zest_mobile/app/modules/auth/forgot_password/views/forgot_password_email_sent_view.dart';
import 'package:zest_mobile/app/modules/auth/forgot_password/views/forgot_password_password_updated_view.dart';
import 'package:zest_mobile/app/modules/auth/forgot_password/views/forgot_password_set_new_password_view.dart';
import 'package:zest_mobile/app/modules/auth/forgot_password/views/forgot_password_view.dart';
import 'package:zest_mobile/app/modules/auth/login/bindings/login_binding.dart';
import 'package:zest_mobile/app/modules/auth/login/views/login_view.dart';
import 'package:zest_mobile/app/modules/auth/register/bindings/register_binding.dart';
import 'package:zest_mobile/app/modules/auth/register/bindings/register_create_profile_binding.dart';
import 'package:zest_mobile/app/modules/auth/register/bindings/register_verify_email_success_binding.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_create_profile_choose_location_view.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_create_profile_view.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_success.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_view.dart';
import 'package:zest_mobile/app/modules/auth/register/bindings/register_verify_email_binding.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_verify_email_view.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_verify_email_success.dart';
import 'package:zest_mobile/app/modules/home/bindings/main_home_binding.dart';
import 'package:zest_mobile/app/modules/home/views/main_home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.mainHome,
      page: () => const MainHomeView(),
      binding: MainHomeBinding(),
    ),

    // Auth
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.registerVerifyEmail,
      page: () => const RegisterVerifyEmailView(),
      binding: RegisterVerifyEmailBinding(),
    ),
    GetPage(
      name: AppRoutes.registerVerifyEmailSuccess,
      page: () => const RegisterVerifyEmailSuccessView(),
      binding: RegisterVerifyEmailSuccessBinding(),
    ),
    GetPage(
      name: AppRoutes.registerCreateProfile,
      page: () => const RegisterCreateProfileView(),
      binding: RegisterCreateProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.registerCreateProfileChooseLocation,
      page: () => const RegisterCreateProfileChooseLocationView(),
      binding: RegisterCreateProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.registerSuccess,
      page: () => const RegisterSuccessView(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordEmailSent,
      page: () => const ForgotPasswordEmailSentView(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordSetNew,
      page: () => const ForgotPasswordSetNewPasswordView(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordUpdated,
      page: () => const ForgotPasswordPasswordUpdatedView(),
    ),
  ];
}
