import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';

class DetailClubController extends GetxController {
  final String clubId;

  DetailClubController({required this.clubId});

  Rx<ClubModel?> club = Rx<ClubModel?>(null);
  RxBool isLoading = false.obs;

  final ClubService _clubService = sl<ClubService>();

  @override
  void onReady() {
    super.onReady();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      isLoading.value = true;
      ClubModel resp = await _clubService.getDetail(clubId: clubId);
      club.value = resp;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}