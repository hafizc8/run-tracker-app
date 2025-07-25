import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_challenge_form.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_team_model.dart'
    as team;
import 'package:zest_mobile/app/core/models/model/event_model.dart' as event;
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/challenge_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class ChallangeEditController extends GetxController {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  var isLoading = false.obs;
  var isLoadingTeams = false.obs;

  var form = CreateChallengeFormModel().obs;
  var formOriginal = CreateChallengeFormModel().obs;

  bool get isEdited => formOriginal.value.isValidToUpdate(form.value);

  final _authService = sl<AuthService>();
  final _challengeService = sl<ChallengeService>();
  String get userId => _authService.user?.id ?? ''; // userId
  String challengeId = '';
  ChallengeDetailModel? challengeDetail;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ChallengeDetailModel) {
      challengeDetail = Get.arguments as ChallengeDetailModel;
      initFormEdit(Get.arguments as ChallengeDetailModel);
    }
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    challengeDetail = null;
    challengeId = '';
    super.onClose();
  }

  void initFormEdit(ChallengeDetailModel challenge) async {
    challengeId = challenge.id ?? '';
    form.value = form.value.copyWith(
      title: challenge.title,
      mode: challenge.mode,
      type: challenge.type,
      target: challenge.target,
      startDate: challenge.startDate,
      endDate: challenge.endDate,
    );
    formOriginal.value = form.value;
    startDateController.text =
        DateFormat('yyyy-MM-dd').format(form.value.startDate!);
    if (challenge.mode == 1) {
      endDateController.text =
          DateFormat('yyyy-MM-dd').format(form.value.endDate!);
    }
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: form.value.startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Format tanggal (misalnya: 19-07-2025)
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      if (isStartDate) {
        startDateController.text = formattedDate;
        form.value = form.value.copyWith(startDate: picked);
      } else {
        endDateController.text = formattedDate;
        form.value = form.value.copyWith(endDate: picked);
      }
      // Set ke controller
    }
  }

  Future<void> updateChallenge({bool isTeam = false}) async {
    isLoading.value = true;
    try {
      ChallengeModel? res = await _challengeService.updateChallenge(
        form.value,
        challengeId,
      );
      if (res != null) {
        if (isTeam) {
          Get.back();
          Get.back(result: res);
        }
        Get.back(result: res);
      }
    } on AppException catch (e) {
      if (e.type == AppExceptionType.validation) {
        form.value = form.value.setErrors(e.errors!);
        return;
      }
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Menyimpan nama sementara ketika diedit
  final tempEditedNames = <int, String>{}.obs;

  void toggleEditTeam(int index, bool isEdit) {
    final currentTeams = form.value.teams ?? [];
    final currentTeam = currentTeams[index];

    // Masukkan nama awal ke temp saat mulai edit
    if (isEdit) {
      tempEditedNames[index] = currentTeam.name ?? '';
    } else {
      tempEditedNames.remove(index); // bersihkan saat selesai
    }

    final updatedTeam = currentTeam.copyWith(isEdit: isEdit);
    final updatedTeams = [...currentTeams]..[index] = updatedTeam;
    form.value = form.value.copyWith(teams: updatedTeams);
  }

  void updateTempName(int index, String value) {
    tempEditedNames[index] = value;
  }

  void saveEdit(int index) {
    final name = tempEditedNames[index];
    if (name == null) return;

    final teams = form.value.teams ?? [];
    final updatedTeam = teams[index].copyWith(name: name, isEdit: false);

    final updatedTeams = [...teams]..[index] = updatedTeam;
    form.value = form.value.copyWith(teams: updatedTeams);

    tempEditedNames.remove(index);
  }

  void cancelEdit(int index) {
    final teams = form.value.teams ?? [];
    final oldName = teams[index].name;
    tempEditedNames[index] = oldName ?? '';

    toggleEditTeam(index, false); // keluar dari mode edit
  }

  void deleteTeam(int index, bool isOwner) {
    if (isOwner) {
      Get.snackbar(
        'Error',
        'You cannot delete your team',
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    final currentTeams = form.value.teams ?? [];
    final updatedTeams = [...currentTeams]..removeAt(index);
    form.value = form.value.copyWith(teams: updatedTeams);
  }

  bool showDeleteTeam(int index) {
    final teams = form.value.teams ?? [];
    var result = (challengeDetail?.totalUsersTeams.length ?? 0) >= teams.length
        ? (challengeDetail?.totalUsersTeams[index].team == teams[index].name &&
            challengeDetail?.totalUsersTeams[index].total_users == 0)
        : true;

    return result;
  }

  void toChallengeTeam() {
    loadTeams();
    Get.toNamed(AppRoutes.challengeEditTeam);
  }

  Future<List<team.ChallengeTeamsModel>> getUserOnTeam(String team) async {
    try {
      final response =
          await _challengeService.challengeUser(challengeId, team: team);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadTeams() async {
    if ((challengeDetail?.teams.length ?? 0) == 0) return;
    try {
      isLoadingTeams.value = true;
      final results = await Future.wait(
        challengeDetail!.teams.map((team) async {
          final data = await getUserOnTeam(team);
          return MapEntry(team, data);
        }),
      );
      final List<Teams> teams = results.map((entry) {
        return Teams(
          id: const Uuid().v4(),
          name: entry.key,
          isOwner: entry.value.any((e) => e.user?.id == userId),
          members: entry.value
              .map(
                (e) => event.User(
                  id: e.user?.id,
                  name: e.user?.name,
                  imagePath: e.user?.imagePath,
                  imageUrl: e.user?.imageUrl,
                ),
              )
              .toList(),
        );
      }).toList();
      form.value = form.value.copyWith(teams: teams);
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingTeams.value = false;
    }
  }

  void addTeam() {
    if ((form.value.teams?.length ?? 0) >= 4) {
      Get.snackbar(
        'Warning!',
        'You cannot add more than 4 teams',
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    form.value = form.value.copyWith(teams: [
      ...(form.value.teams ?? []),
      Teams(id: const Uuid().v4(), name: 'New Team', members: const []),
    ]);
  }
}
