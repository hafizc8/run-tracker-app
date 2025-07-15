import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/forms/create_challenge_form.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class ChallangeCreateController extends GetxController {
  var isLoading = false.obs;
  var form = CreateChallengeFormModel().obs;
  final _authService = sl<AuthService>();

  void storeChallenge() {}

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
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final currentTeams = form.value.teams ?? [];
    final updatedTeams = [...currentTeams]..removeAt(index);
    form.value = form.value.copyWith(teams: updatedTeams);
  }

  void toChallengeTeam() {
    form.value = form.value.copyWith(
      teams: [
        Teams(isOwner: true, name: 'Blue Team', members: [
          User(
            id: _authService.user?.id ?? '',
            name: _authService.user?.name ?? '',
            imagePath: _authService.user?.imagePath ?? '',
            imageUrl: _authService.user?.imageUrl ?? '',
          ),
        ]),
        const Teams(name: 'Orange Team', members: []),
      ],
    );
    Get.toNamed(AppRoutes.challengeCreateTeam);
  }

  void addTeam() {
    if ((form.value.teams?.length ?? 0) < 4) {
      form.value = form.value.copyWith(teams: [
        ...(form.value.teams ?? []),
        const Teams(name: 'New Team', members: []),
      ]);
    }
  }
}
