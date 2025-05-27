import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';

import 'dart:async';

import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class SocialSearchController extends GetxController {
  var isLoadingPeopleYouMayKnow = false.obs;
  var isLoadingFriends = false.obs;
  var isLoadingFollow = false.obs;
  var hasReacheMax = false.obs;
  var resultSearchEmpty = false.obs;
  var userId = ''.obs;

  final _userService = sl<UserService>();

  var friendsPeopleYouMayKnow = <UserMiniModel>[].obs;
  var friends = <UserMiniModel>[].obs;
  var search = ''.obs;

  final scrollFriendsController = ScrollController();

  var pageFriend = 1;

  final _debouncer = Debouncer(milliseconds: 400);

  // for search club
  var isLoadingClubYouMayKnow = false.obs;
  var isLoadingClubs = false.obs;
  var isLoadingClubJoin = false.obs;
  var hasReacheMaxClub = false.obs;
  var resultSearchEmptyClub = false.obs;
  var clubId = ''.obs;

  final _clubService = sl<ClubService>();

  var clubMayYouKnow = <ClubModel>[].obs;
  var clubs = <ClubModel>[].obs;
  var searchClub = ''.obs;

  final scrollClubsController = ScrollController();

  var pageClub = 1;

  late TabController tabController;

  void onSearchChanged(String input) {
    if (search.value != input) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
    }
    search.value = input;

    _debouncer.run(() => searchFriends(input));
  }

  @override
  void onInit() {
    super.onInit();
    searchPeopleYouMayKnow();
    searchClubYouMayKnow();
  }

  @override
  void onClose() {
    scrollFriendsController.dispose();
    scrollClubsController.dispose();
    _debouncer.dispose();
    super.onClose();
  }

  Future<void> searchPeopleYouMayKnow() async {
    isLoadingPeopleYouMayKnow.value = true;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: 1,
        followStatus: 'followable',
      );
      List<UserMiniModel> users = response.data;
      if (response.data.length > 10) {
        users = response.data.sublist(0, 10);
      }

      friendsPeopleYouMayKnow.value = users;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingPeopleYouMayKnow.value = false;
    }
  }

  Future<void> searchFriends(String input) async {
    if (input.isEmpty) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
      return;
    }

    if (isLoadingFriends.value || hasReacheMax.value) return;
    isLoadingFriends.value = true;
    resultSearchEmpty.value = false;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: pageFriend,
        search: input,
      );

      pageFriend++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      if (response.data.isEmpty) {
        resultSearchEmpty.value = true;
      } else {
        friends.value += response.data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingFriends.value = false;
    }
  }

  Future<void> follow(String id) async {
    userId.value = id;
    isLoadingFollow.value = true;
    try {
      bool res = await _userService.followUser(id);

      if (res) {
        if (search.value.isNotEmpty && friends.isNotEmpty) {
          int index = friends.indexWhere((element) => element.id == id);
          if (index != -1) {
            final user = friends[index];
            friends[index] = user.copyWith(
              isFollower: res ? 1 : 0,
            );
          }
        } else {
          int index =
              friendsPeopleYouMayKnow.indexWhere((element) => element.id == id);
          if (index != -1) {
            final user = friendsPeopleYouMayKnow[index];
            friendsPeopleYouMayKnow[index] = user.copyWith(
              isFollower: res ? 1 : 0,
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      userId.value = '';
      isLoadingFollow.value = false;
    }
  }

  Future<void> unFollow(String id) async {
    userId.value = id;
    isLoadingFollow.value = true;
    try {
      bool res = await _userService.unFollowUser(id);

      if (res) {
        if (search.value.isNotEmpty && friends.isNotEmpty) {
          int index = friends.indexWhere((element) => element.id == id);
          if (index != -1) {
            final user = friends[index];
            friends[index] = user.copyWith(
              isFollower: res ? 0 : 1,
            );
          }
        } else {
          int index =
              friendsPeopleYouMayKnow.indexWhere((element) => element.id == id);
          if (index != -1) {
            final user = friendsPeopleYouMayKnow[index];
            friendsPeopleYouMayKnow[index] = user.copyWith(
              isFollower: res ? 0 : 1,
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      userId.value = '';
      isLoadingFollow.value = false;
    }
  }

  // FOR CLUB
  // FOR CLUB
  // FOR CLUB
  void onSearchClubChanged(String input) {
    if (searchClub.value != input) {
      clubs.clear();
      pageClub = 1;
      hasReacheMaxClub.value = false;
    }
    searchClub.value = input;

    _debouncer.run(() => searchClubs(input));
  }

  Future<void> searchClubYouMayKnow() async {
    isLoadingClubYouMayKnow.value = true;
    try {
      PaginatedDataResponse<ClubModel> response =
          await _clubService.getAll(page: 1, joinStatus: 'unjoined', random: 1);
      List<ClubModel> clubs = response.data;
      if (response.data.length > 10) {
        clubs = response.data.sublist(0, 10);
      }

      clubMayYouKnow.value = clubs;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingClubYouMayKnow.value = false;
    }
  }

  Future<void> searchClubs(String input) async {
    if (input.isEmpty) {
      clubs.clear();
      pageClub = 1;
      hasReacheMaxClub.value = false;
      return;
    }

    if (isLoadingClubs.value || hasReacheMaxClub.value) return;

    isLoadingClubs.value = true;
    resultSearchEmptyClub.value = false;

    try {
      PaginatedDataResponse<ClubModel> response = await _clubService.getAll(
        page: pageClub,
        search: input,
      );

      pageClub++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) {
        hasReacheMaxClub.value = true;
      }

      if (response.data.isEmpty) {
        resultSearchEmptyClub.value = true;
      } else {
        clubs.value += response.data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingClubs.value = false;
    }
  }

  Future<void> joinClub(String id) async {
    clubId.value = id;
    isLoadingClubJoin.value = true;
    try {
      bool res = await _clubService.accOrJoinOrLeave(clubId: id);

      if (res) {
        if (searchClub.value.isNotEmpty && clubs.isNotEmpty) {
          int index = clubs.indexWhere((element) => element.id == id);
          if (index != -1) {
            final club = clubs[index];
            clubs[index] = club.copyWith(
              isJoined: res,
            );
          }
        } else {
          int index = clubMayYouKnow.indexWhere((element) => element.id == id);
          if (index != -1) {
            final club = clubMayYouKnow[index];
            clubMayYouKnow[index] = club.copyWith(
              isJoined: res,
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      clubId.value = '';
      isLoadingClubJoin.value = false;
    }
  }
}
