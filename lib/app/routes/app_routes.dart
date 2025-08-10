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
  static const registerVerifyEmailSuccess =
      '/auth/register-verify-email-success';
  static const registerCreateProfile = '/auth/register-create-profile';

  static const registerCreateProfileChooseLocation =
      '/auth/register-create-profile-choose-location';

  static const social = '/social';
  static const socialSearch = '/social/search';
  static const socialYourPageActivityDetail =
      '/social/your-page/activity-detail';
  static const socialYourPageEventDetail = '/social/your-page/event-detail';
  static const socialYourPageEventDetailInviteFriend =
      '/social/your-page/event-detail/invite-friend';
  static const chooseLocation = '/choose-location';
  static const socialEditPost = '/social/edit-post';

  // profile
  static const profileMain = '/profile/main';
  static const profileUser = '/profile/user';
  static const profileEdit = '/profile/edit';
  static const settings = '/settings';
  static const activity = '/activity';
  static const badges = '/badges';
  static const profileSocialInfo = '/profile/social-info';

  // Event
  static const eventCreate = '/event/create';
  static const eventSeeAllParticipant = '/event/seel-all-participant';
  static const chooseLocationEvent = '/choose-location-event';
  // club
  static const createClub = '/create-club';
  static const detailClub = '/detail-club';
  static const updateClub = '/update-club';
  static const previewClub = '/preview-club';
  static const memberListInClub = '/detail-club/member-list';
  static const inviteToClub = '/detail-club/invite-to-club';

  // activity
  static const activityStart = '/activity/start';
  static const activityRecord = '/activity/record';
  static const activityEdit = '/activity/edit';

  static const debug = '/debug';
  static const logViewer = '/log-viewer';

  // leaderboard
  static const leaderboard = '/leaderboard';

  // daily streak
  static const dailyStreak = '/daily-streak';

  static const challengeCreate = '/challenge/create';
  static const challengeEdit = '/challenge/edit';
  static const challengeCreateTeam = '/challenge/create/team';
  static const challengeEditTeam = '/challenge/edit/team';
  static const challengeInviteFriend = '/challenge/invite';
  static const challengedetails = '/challenge/details';
  static const challengedetailsInvite = '/challenge/details/invite';

  // notification
  static const notification = '/notification';

  // Share
  static const shareBadges = '/share/badges';
  static const shareDailyGoals = '/share/daily-goals';
  static const shareLevelUp = '/share/level-up';
  static const shareChallenge = '/share/challenge';
  static const shareEvent = '/share/event';
  static const shareProfile = '/share/profile';
  static const shareClub = '/share/club';
  static const shareActivity = '/share/activity';
}
