import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_team_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/challenge_service.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/widget/confirmation.dart';

class DetailChallangeController extends GetxController {
  var isLoading = false.obs;
  var isLoadingCancel = false.obs;
  var isLoadingTeams = false.obs;
  final _challengeService = sl<ChallengeService>();
  var challengeId = "";
  Rx<ChallengeDetailModel?> detailChallenge = Rx<ChallengeDetailModel?>(null);
  Rx<ChallengeModel?> lastdetailChallenge = Rx<ChallengeModel?>(null);
  Rx<Map<String, List<ChallengeTeamsModel>>> teams =
      Rx<Map<String, List<ChallengeTeamsModel>>>({});

  final _authService = sl<AuthService>();
  String get userId => _authService.user?.id ?? ''; // userId

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      challengeId = Get.arguments['challengeId'];
      init();
    }
  }

  @override
  void onClose() {
    super.onClose();
    challengeId = "";
    detailChallenge.value = null;
    lastdetailChallenge.value = null;
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      ChallengeDetailModel? resp =
          await _challengeService.detailChallenge(challengeId);
      detailChallenge.value = resp;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmCancel() async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => cancelChallenge(),
          title: 'Cancel Challenge?',
          subtitle:
              'Are you sure you want to cancel this challenge? This will remove all participants and delete the challenge permanently.',
          labelConfirm: 'Cancel Challenge',
          isLoading: isLoadingCancel.value,
        ),
      ),
    );
  }

  Future<void> cancelChallenge() async {
    try {
      isLoadingCancel.value = true;
      ChallengeModel? resp =
          await _challengeService.cancelChallenge(challengeId);
      lastdetailChallenge.value = resp;
      Get.back();
      Get.back(result: resp);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingCancel.value = false;
    }
  }

  Future<List<ChallengeTeamsModel>> getUserOnTeam(String team) async {
    try {
      final response = await _challengeService.challengeUser(challengeId, team);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadTeams() async {
    if ((detailChallenge.value?.teams.length ?? 0) == 0) return;
    try {
      isLoadingTeams.value = true;
      final results = await Future.wait(
        detailChallenge.value!.teams.map((team) async {
          final data = await getUserOnTeam(team);
          return MapEntry(team, data);
        }),
      );

      teams.value = Map.fromEntries(results);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingTeams.value = false;
    }
  }

  Future<void> init() async {
    Future.microtask(() async {
      await load();
      await loadTeams();
    });
  }
}
