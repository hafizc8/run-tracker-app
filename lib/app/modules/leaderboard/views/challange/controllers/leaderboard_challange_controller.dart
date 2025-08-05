import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/services/challenge_service.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';

class LeaderboardChallangeController extends GetxController {
  final _challengeService = sl<ChallengeService>();
  var challenges = <ChallengeModel>[].obs;

  var isLoadingChallenge = false.obs;
  var hasReacheMaxChallenge = false.obs;
  var pageChallenge = 1;
  ScrollController challengeController = ScrollController();

  @override
  void onInit() {
    getChallenges();
    challengeController.addListener(() {
      var maxScroll = challengeController.position.pixels >= challengeController.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMaxChallenge.value) {
        getChallenges();
      }
    });
    super.onInit();
  }

  Future<void> getChallenges({bool refresh = false}) async {
    if (refresh) {
      print('refresh challenges');
      challenges.clear();
      pageChallenge = 1;
      hasReacheMaxChallenge.value = false;
    }
    if (isLoadingChallenge.value || hasReacheMaxChallenge.value) return;
    isLoadingChallenge.value = true;
    try {
      PaginatedDataResponse<ChallengeModel> response = await _challengeService.getChallenges(
        page: pageChallenge,
        status: 'joined',
        limit: 5,
      );

      pageChallenge++;

      if ((response.pagination.next == null || response.pagination.next == '') || response.pagination.total < 5) {
        hasReacheMaxChallenge.value = true;
      }

      challenges.value += response.data;

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingChallenge.value = false;
    }
  }
}