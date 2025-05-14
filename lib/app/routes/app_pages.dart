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
import 'package:zest_mobile/app/modules/auth/register/bindings/register_verify_email_binding.dart';
import 'package:zest_mobile/app/modules/auth/register/bindings/register_verify_email_success_binding.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_create_profile_view.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_success.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_verify_email_success.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_verify_email_view.dart';
import 'package:zest_mobile/app/modules/auth/register/views/register_view.dart';
import 'package:zest_mobile/app/modules/choose_location/bindings/choose_location_binding.dart';
import 'package:zest_mobile/app/modules/choose_location/views/choose_location_view.dart';
import 'package:zest_mobile/app/modules/club/partial/create_club/bindings/create_club_binding.dart';
import 'package:zest_mobile/app/modules/club/partial/create_club/views/create_club_view.dart';
import 'package:zest_mobile/app/modules/home/bindings/main_home_binding.dart';
import 'package:zest_mobile/app/modules/home/views/main_home_view.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/bindings/profile_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/views/profile_view.dart';
import 'package:zest_mobile/app/modules/social/bindings/social_binding.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/social_for_you_event_detail_invite_friend_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/social_for_you_event_detail_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/bindings/social_search_binding.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/views/social_search_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/post/edit_post_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_activity_detail_view.dart';
import 'package:zest_mobile/app/modules/social/views/social_view.dart';
import 'package:zest_mobile/app/modules/main_profile/bindings/badges_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/bindings/settings_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/activity/bindings/activity_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/activity/views/activity_view.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/edit_profile/bindings/edit_profile_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/edit_profile/views/edit_profile_view.dart';
import 'package:zest_mobile/app/modules/main_profile/views/badges_view.dart';
import 'package:zest_mobile/app/modules/main_profile/views/main_profile_view.dart';
import 'package:zest_mobile/app/modules/main_profile/views/settings_view.dart';
import 'package:zest_mobile/app/modules/splash/bindings/splash_binding.dart';
import 'package:zest_mobile/app/modules/splash/views/splash_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

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
      name: AppRoutes.chooseLocation,
      page: () => const ChooseLocationView(),
      binding: ChooseLocationBinding(),
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

    GetPage(
      name: AppRoutes.social,
      page: () => const SocialView(),
      binding: SocialBinding(),
    ),
    GetPage(
      name: AppRoutes.socialYourPageActivityDetail,
      page: () => const SocialYourPageActivityDetailView(),
    ),
    GetPage(
      name: AppRoutes.socialYourPageEventDetail,
      page: () => const SocialForYouEventDetailView(),
    ),
    GetPage(
      name: AppRoutes.socialYourPageEventDetailInviteFriend,
      page: () => const SocialForYouEventDetaiInviteFriendView(),
    ),
    GetPage(
      name: AppRoutes.socialEditPost,
      page: () => const EditPostView(),
    ),

    GetPage(
      name: AppRoutes.profileMain,
      page: () => const MainProfileView(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.activity,
      page: () => const ActivityView(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: AppRoutes.badges,
      page: () => const BadgesView(),
      binding: BadgesBinding(),
    ),
    GetPage(
      name: AppRoutes.profileEdit,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.profileUser,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.socialSearch,
      page: () => const SocialSearchView(),
      binding: SocialSearchBinding(),
    ),

    // club
    GetPage(
      name: AppRoutes.createClub,
      page: () => const CreateClubView(),
      binding: CreateClubBinding(),
    ),
  ];
}
