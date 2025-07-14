import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/forms/create_challenge_form.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class ChallangeCreateController extends GetxController {
  var isLoading = false.obs;
  var form = CreateChallengeFormModel().obs;
  final _authService = sl<AuthService>();

  void storeChallenge() {}

  void toChallengeTeam() {
    form.value = form.value.copyWith(
      teams: [
        Teams(name: 'Blue Team', members: [
          User(
            id: _authService.user?.id ?? '',
            name: _authService.user?.name ?? '',
            imagePath: _authService.user?.imagePath ?? '',
            imageUrl: _authService.user?.imageUrl ?? '',
          ),
          User(
            id: _authService.user?.id ?? '',
            name: _authService.user?.name ?? '',
            imagePath: _authService.user?.imagePath ?? '',
            imageUrl: _authService.user?.imageUrl ?? '',
          ),
        ]),
        const Teams(name: 'Orange Team', members: []),
      ],
    );
    Get.toNamed(AppRoutes.challengeCreateTeam);
  }
}
