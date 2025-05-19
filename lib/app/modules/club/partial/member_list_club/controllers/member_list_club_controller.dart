import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_member_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class MemberListClubController extends GetxController {
  final String clubId;

  MemberListClubController({required this.clubId});

  RxBool isLoading = false.obs;

  final ClubService _clubService = sl<ClubService>();

  final ScrollController memberListScrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  var hasReacheMax = false.obs;
  var pageMember = 1;

  RxList<ClubMemberModel?> clubMembers = <ClubMemberModel?>[].obs;

  @override
  void onReady() {
    super.onReady();
    loadMembers();
  }

  @override
  void onInit() {
    super.onInit();
    memberListScrollController.addListener(() {
      final position = memberListScrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

      _debouncer.run(() {
        if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
          loadMembers();
        }
      });
    });
  }

  Future<void> loadMembers() async {
    if (isLoading.value || hasReacheMax.value) return;

    try {
      isLoading.value = true;

      final response = await _clubService.getAllMembers(clubId: clubId, page: pageMember);

      // Deteksi akhir halaman dengan lebih akurat
      if ((response.pagination.next == null || response.pagination.next!.isEmpty) || 
          response.data.isEmpty || 
          response.data.length < 20) {
        hasReacheMax.value = true;
      }

      // Tambahkan hasil ke list
      clubMembers.addAll(response.data);

      // Increment page terakhir
      pageMember++;

    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}