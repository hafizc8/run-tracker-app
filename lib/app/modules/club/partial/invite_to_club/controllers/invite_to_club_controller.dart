import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class InviteToClubController extends GetxController {
  final String clubId;

  InviteToClubController({required this.clubId});

  RxBool isLoading = false.obs;
  RxBool isLoadingInviteToClub = false.obs;

  final ClubService _clubService = sl<ClubService>();
  final UserService _userService = sl<UserService>();

  final ScrollController followersScrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  var hasReacheMax = false.obs;
  var page = 1;
  var search = ''.obs;
  var resultSearchEmpty = false.obs;
  TextEditingController searchController = TextEditingController();

  RxList<UserMiniModel?> userFollowers = <UserMiniModel?>[].obs;

  RxList<String> selectedUser = <String>[].obs;

  @override
  void onReady() {
    super.onReady();
    loadFollowers();
  }

  @override
  void onInit() {
    super.onInit();
    followersScrollController.addListener(() {
      final position = followersScrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

      _debouncer.run(() {
        if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
          loadFollowers();
        }
      });
    });
  }

  Future<void> loadFollowers({bool refresh = false}) async {
    if (refresh) {
      userFollowers.clear();
      page = 1;
      hasReacheMax.value = false;
      search.value = '';
      searchController.text = '';
    }
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
            page: page,
            followStatus: 'followers',
            checkClub: clubId,
          );

      page++;

      if ((response.pagination.next == null || response.pagination.next == '') || response.pagination.total < 20) hasReacheMax.value = true;

      userFollowers.value += response.data;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String input) {
    if (search.value != input) {
      userFollowers.clear();
      page = 1;
      hasReacheMax.value = false;
    }
    search.value = input;

    _debouncer.run(() => searchFriends(input));
  }

  Future<void> searchFriends(String input) async {
    if (input.isEmpty) {
      userFollowers.clear();
      page = 1;
      hasReacheMax.value = false;
      return;
    }

    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    resultSearchEmpty.value = false;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: page,
        search: input,
        followStatus: 'followers',
        checkClub: clubId,
      );

      page++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      if (response.data.isEmpty) {
        resultSearchEmpty.value = true;
      } else {
        userFollowers.value += response.data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(String item) {
    if (selectedUser.contains(item)) {
      selectedUser.remove(item);
    } else {
      selectedUser.add(item);
    }

    userFollowers.refresh();
  }

  Future<void> inviteToClub() async {
    try {
      isLoadingInviteToClub.value = true;

      await _clubService.inviteToClub(clubId: clubId, userIds: selectedUser);

      Get.snackbar('Success', 'Successfully invite to club');

      selectedUser.clear();
      loadFollowers(refresh: true);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingInviteToClub.value = false;
    }
  }
}