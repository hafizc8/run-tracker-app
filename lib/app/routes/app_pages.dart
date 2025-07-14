import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/activity/edit_activity/bindings/edit_activity_binding.dart';
import 'package:zest_mobile/app/modules/activity/edit_activity/views/edit_activity_view.dart';
import 'package:zest_mobile/app/modules/activity/record_activity/bindings/record_activity_binding.dart';
import 'package:zest_mobile/app/modules/activity/record_activity/views/record_activity_view.dart';
import 'package:zest_mobile/app/modules/activity/start_activity/bindings/start_activity_binding.dart';
import 'package:zest_mobile/app/modules/activity/start_activity/views/start_activity_view.dart';
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
import 'package:zest_mobile/app/modules/challenge/bindings/create_challenge_binding.dart';
import 'package:zest_mobile/app/modules/challenge/views/create_challenge_team_view.dart';
import 'package:zest_mobile/app/modules/challenge/views/create_challenge_view.dart';
import 'package:zest_mobile/app/modules/choose_location/bindings/choose_location_binding.dart';
import 'package:zest_mobile/app/modules/choose_location/views/choose_location_view.dart';
import 'package:zest_mobile/app/modules/club/partial/invite_to_club/bindings/invite_to_club_binding.dart';
import 'package:zest_mobile/app/modules/club/partial/invite_to_club/views/invite_to_club_view.dart';
import 'package:zest_mobile/app/modules/club/partial/preview_club/bindings/preview_club_binding.dart';
import 'package:zest_mobile/app/modules/club/partial/preview_club/views/preview_club_view.dart';
import 'package:zest_mobile/app/modules/club/partial/update_club/bindings/update_club_binding.dart';
import 'package:zest_mobile/app/modules/club/partial/update_club/views/update_club_view.dart';
import 'package:zest_mobile/app/modules/daily_streak/bindings/daily_streak_binding.dart';
import 'package:zest_mobile/app/modules/daily_streak/views/daily_streak_view.dart';
import 'package:zest_mobile/app/modules/debug/views/debug_view.dart';
import 'package:zest_mobile/app/modules/leaderboard/bindings/leaderboard_binding.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/leaderboard_view.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/challenge/bindings/challenge_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/bindings/social_info_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/social_info/views/social_info_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/choose_location_event/bindings/choose_location_event_binding.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/choose_location_event/views/choose_location_event_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/bindings/event_invite_binding.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/bindings/event_detail_binding.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/bindings/event_see_all_participant_binding.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/views/create_view.dart';
import 'package:zest_mobile/app/modules/club/partial/create_club/bindings/create_club_binding.dart';
import 'package:zest_mobile/app/modules/club/partial/create_club/views/create_club_view.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/bindings/detail_club_binding.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/views/detail_club_view.dart';
import 'package:zest_mobile/app/modules/club/partial/member_list_club/bindings/member_list_club_binding.dart';
import 'package:zest_mobile/app/modules/club/partial/member_list_club/views/member_list_club_view.dart';
import 'package:zest_mobile/app/modules/home/bindings/main_home_binding.dart';
import 'package:zest_mobile/app/modules/home/views/main_home_view.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/bindings/profile_binding.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/views/profile_view.dart';
import 'package:zest_mobile/app/modules/social/bindings/social_binding.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/views/see_all_participant_view.dart';
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
      page: () => SocialForYouEventDetailView(),
      binding: EventDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.chooseLocationEvent,
      page: () => const ChooseLocationEventView(),
      binding: ChooseLocationEventBinding(),
    ),
    GetPage(
      name: AppRoutes.socialYourPageEventDetailInviteFriend,
      page: () => const SocialForYouEventDetaiInviteFriendView(),
      binding: EventInviteBinding(),
    ),
    GetPage(
      name: AppRoutes.eventSeeAllParticipant,
      page: () => const SocialForYouEventDetailSeelAllParticipantView(),
      binding: EventDetailSeeAllParticipantBinding(),
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
      page: () => SettingsView(),
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
      name: AppRoutes.profileSocialInfo,
      page: () => SocialInfoView(),
      binding: SocialInfoBinding(),
    ),
    GetPage(
      name: AppRoutes.socialSearch,
      page: () => const SocialSearchView(),
      binding: SocialSearchBinding(),
    ),
    GetPage(
      name: AppRoutes.eventCreate,
      page: () => const EventCreateView(),
    ),
    // club
    GetPage(
      name: AppRoutes.createClub,
      page: () => const CreateClubView(),
      binding: CreateClubBinding(),
    ),
    GetPage(
      name: AppRoutes.detailClub,
      page: () => DetailClubView(),
      binding: DetailClubBinding(),
    ),
    GetPage(
      name: AppRoutes.memberListInClub,
      page: () => MemberListClubView(),
      binding: MemberListClubBinding(),
    ),
    GetPage(
      name: AppRoutes.inviteToClub,
      page: () => const InviteToClubView(),
      binding: InviteToClubBinding(),
    ),
    GetPage(
      name: AppRoutes.updateClub,
      page: () => const UpdateClubView(),
      binding: UpdateClubBinding(),
    ),
    GetPage(
      name: AppRoutes.previewClub,
      page: () => const PreviewClubView(),
      binding: PreviewClubBinding(),
    ),
    // activity
    GetPage(
      name: AppRoutes.activityStart,
      page: () => const StartActivityView(),
      binding: StartActivityBinding(),
    ),
    GetPage(
      name: AppRoutes.activityRecord,
      page: () => const RecordActivityView(),
      binding: RecordActivityBinding(),
    ),
    GetPage(
      name: AppRoutes.activityEdit,
      page: () => const EditActivityView(),
      binding: EditActivityBinding(),
    ),

    GetPage(
      name: AppRoutes.logViewer,
      page: () => const DebugView(),
    ),

    GetPage(
      name: AppRoutes.leaderboard,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
    ),

    GetPage(
      name: AppRoutes.dailyStreak,
      page: () => const DailyStreakView(),
      binding: DailyStreakBinding(),
    ),
    
    GetPage(
      name: AppRoutes.challengeCreate,
      page: () => const ChallengeCreateView(),
      binding: ChallengeCreateBinding(),
    ),
    
    GetPage(
      name: AppRoutes.challengeCreateTeam,
      page: () => const ChallengeCreateTeamView(),
      binding: ChallengeCreateBinding(),
    ),
  ];
}
