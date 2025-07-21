import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/services/challenge_service.dart';

class DetailChallangeController extends GetxController {
  var isLoading = false.obs;
  final _challengeService = sl<ChallengeService>();
  var challengeId = "";
  Rx<ChallengeDetailModel?> detailChallenge = Rx<ChallengeDetailModel?>(null);

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      challengeId = Get.arguments['challengeId'];
      load();
    }
  }

  @override
  void onClose() {
    super.onClose();
    challengeId = "";
    detailChallenge.value = null;
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
}
