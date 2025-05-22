import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_member_model.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class PreviewClubController extends GetxController {
  final String clubId;

  PreviewClubController({required this.clubId});

  Rx<ClubModel?> club = Rx<ClubModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isLoadingMembers = false.obs;
  RxBool isLoadingJoin = false.obs;
  RxList<String> memberAvatars = <String>[].obs;

  final ClubService _clubService = sl<ClubService>();

  @override
  void onReady() {
    super.onReady();
    loadDetail();
    getMembers();
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

  Future<void> getMembers() async {
    try {
      memberAvatars.clear();
      isLoadingMembers.value = true;

      final response = await _clubService.getAllMembers(
        clubId: clubId,
        page: 1,
        limit: 10,
      );

      for (ClubMemberModel member in response.data) {
        memberAvatars.add(member.user?.imageUrl ?? '');
      }

      if (response.pagination.total > 10) {
        for (int i = 0; i < response.pagination.total - 10; i++) {
          memberAvatars.add('$i');
        }
      }
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingMembers.value = false;
    }
  }

  Future<void> joinClub() async {
    isLoadingJoin.value = true;
    try {
      bool res = await _clubService.accOrJoinOrLeave(clubId: clubId);

      if (res) {
        Get.snackbar('Success', 'You have joined the club');
        
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back(closeOverlays: true);
        await Get.toNamed(AppRoutes.detailClub, arguments: clubId);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingJoin.value = false;
    }
  }

  String formatFriendsText({
    required List<String>? friendsNames,
    required int? friendsTotal,
  }) {
    if (friendsNames == null || friendsTotal == null || friendsTotal == 0) {
      return '';
    }

    final namesToShow = friendsNames.take(3).toList();
    final remaining = friendsTotal - namesToShow.length;

    if (namesToShow.isEmpty) {
      return '$friendsTotal of your friends joined';
    } else if (namesToShow.length == 1 && remaining <= 0) {
      return '${namesToShow[0]} joined';
    } else if (namesToShow.length == 2 && remaining <= 0) {
      return '${namesToShow[0]} and ${namesToShow[1]} joined';
    } else if (namesToShow.length == 3 && remaining <= 0) {
      return '${namesToShow[0]}, ${namesToShow[1]}, and ${namesToShow[2]} joined';
    } else {
      final nameList = namesToShow.join(', ');
      return '$nameList, and $remaining of your friends joined';
    }
  }

}