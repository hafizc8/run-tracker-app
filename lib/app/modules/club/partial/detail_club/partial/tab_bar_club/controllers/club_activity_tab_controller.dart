import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_activities_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class ClubActivityTabController extends GetxController {
  final String clubId;

  ClubActivityTabController({required this.clubId});

  ScrollController clubActivityScrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);
  RxBool isLoading = false.obs;
  RxBool hasReacheMax = false.obs;
  final ClubService _clubService = sl<ClubService>();
  var page = 1;
  RxList<ClubActivitiesModel?> activities = <ClubActivitiesModel?>[].obs;

  @override
  void onInit() {
    super.onInit();
    getClubActivity();
    clubActivityScrollController.addListener(() {
      final position = clubActivityScrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

      print('clubActivityScrollController ${isNearBottom}, ${position.pixels}, ${position.maxScrollExtent}');

      _debouncer.run(() {
        if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
          getClubActivity();
        }
      });
    });
  }

  Future<void> getClubActivity() async {
    if (isLoading.value || hasReacheMax.value) return;

    try {
      isLoading.value = true;

      final response = await _clubService.getClubActivity(clubId: clubId, page: page);

      // Deteksi akhir halaman dengan lebih akurat
      if (
          (response.pagination.next == null || response.pagination.next!.isEmpty) || 
          response.data.isEmpty 
          || response.data.length < 20
      ) {
        hasReacheMax.value = true;
      }

      // Tambahkan hasil ke list
      activities.addAll(response.data);

      // Increment page terakhir
      page++;

    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}
