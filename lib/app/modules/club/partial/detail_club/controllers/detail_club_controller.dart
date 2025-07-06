import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/widget/confirmation.dart';

class DetailClubController extends GetxController {
  var clubId = ''.obs;

  Rx<ClubModel?> club = Rx<ClubModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isLoadingAction = false.obs;
  var tabs = ['Club Activity', 'Leaderboards'].obs;

  final ClubService _clubService = sl<ClubService>();

  var isExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    clubId.value = Get.arguments as String;
  }

  @override
  void onReady() {
    super.onReady();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      isLoading.value = true;
      ClubModel resp = await _clubService.getDetail(clubId: clubId.value);
      club.value = resp;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmCancelEvent() async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => leaveClub(),
          title: 'Leaving Club',
          subtitle: 'Are you sure to leave from club?',
          labelConfirm: 'Yes, leave',
          isLoading: isLoadingAction.value,
        ),
      ),
    );
  }

  Future<void> leaveClub() async {
    isLoadingAction.value = true;
    try {
      bool resp =
          await _clubService.accOrJoinOrLeave(clubId: clubId.value, leave: 1);
      if (resp) {
        Get.back();
        Get.back();
        Get.snackbar("Success", "Successfully leave club");

        // refresh SocialClubSearchController
        Get.find<SocialClubSearchController>().load(refresh: true);
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingAction.value = false;
    }
  }
}
