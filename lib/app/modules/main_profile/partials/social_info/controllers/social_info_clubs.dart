import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialInfoClubsController extends GetxController {
  var isLoading = false.obs;
  var hasReacheMax = false.obs;
  var resultSearchEmpty = false.obs;
  var userId = ''.obs;
  TextEditingController searchController = TextEditingController();
  final _clubService = sl<ClubService>();

  var clubs = <ClubModel>[].obs;
  var search = ''.obs;

  final scrollClubSearchController = ScrollController();

  var pageClub = 1;
  var total = 0.obs;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['id'] != null) {
        userId.value = Get.arguments['id'];
      }
    }
    scrollClubSearchController.addListener(() {
      var maxScroll = scrollClubSearchController.position.pixels >=
          scrollClubSearchController.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMax.value) {
        load();
      }
    });
  }

  @override
  void onClose() {
    scrollClubSearchController.dispose();
    _debouncer.dispose();
    super.onClose();
  }

  void onSearchChanged(String input) {
    if (search.value != input) {
      clubs.clear();
      pageClub = 1;
      hasReacheMax.value = false;
    }
    search.value = input;
    searchController.text = input;

    _debouncer.run(() => searchClub(input));
  }

  Future<void> searchClub(String input) async {
    if (input.isEmpty) {
      clubs.clear();
      pageClub = 1;
      hasReacheMax.value = false;
    }

    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    resultSearchEmpty.value = false;
    try {
      PaginatedDataResponse<ClubModel> response = await _clubService.getAll(
        page: pageClub,
        search: input,
        random: 0,
        joinedBy: userId.value,
      );

      pageClub++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      if (response.data.isEmpty) {
        resultSearchEmpty.value = true;
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
      isLoading.value = false;
    }
  }

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      clubs.clear();
      pageClub = 1;
      hasReacheMax.value = false;
      search.value = '';
      searchController.text = '';
    }
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<ClubModel> response = await _clubService.getAll(
        page: pageClub,
        random: 0,
        joinedBy: userId.value,
      );

      pageClub++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      clubs.value += response.data;
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

  dynamic goToClubDetails(ClubModel club) {
    Get.toNamed(AppRoutes.detailClub, arguments: club.id);
  }
}
