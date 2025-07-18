import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/forms/create_challenge_form.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class DetailChallangeController extends GetxController {
  var isLoading = false.obs;
  var form = CreateChallengeFormModel().obs;
  final _authService = sl<AuthService>();
  String get userId => _authService.user?.id ?? ''; // userId

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
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    final currentTeams = form.value.teams ?? [];
    final updatedTeams = [...currentTeams]..removeAt(index);
    form.value = form.value.copyWith(teams: updatedTeams);
  }

  void addMembersToTeam(int teamIndex, List<User> newMembers) {
    final teams = form.value.teams ?? [];
    final team = teams[teamIndex];
    final existingMembers = team.members ?? [];

    // Gabungkan dan hilangkan duplikat berdasarkan `id`
    final combinedMembers = [
      ...existingMembers,
      ...newMembers,
    ]
        .fold<Map<String, User>>({}, (map, user) {
          map[user.id!] = user;
          return map;
        })
        .values
        .toList();

    final updatedTeam = team.copyWith(members: combinedMembers);
    final updatedTeams = [...teams]..[teamIndex] = updatedTeam;

    form.value = form.value.copyWith(teams: updatedTeams);
  }

  void removeMemberFromTeam(int teamIndex, int memberIndex) {
    final teams = form.value.teams ?? [];
    final team = teams[teamIndex];
    final updatedMembers = [...?team.members]..removeAt(memberIndex);

    final updatedTeam = team.copyWith(members: updatedMembers);
    final updatedTeams = [...teams]..[teamIndex] = updatedTeam;

    form.value = form.value.copyWith(teams: updatedTeams);
  }

  void toChallengeTeam() {
    form.value = form.value.copyWith(
      teams: [
        Teams(
            id: const Uuid().v4(),
            isOwner: true,
            name: 'Blue Team',
            members: [
              User(
                id: _authService.user?.id ?? '',
                name: _authService.user?.name ?? '',
                imagePath: _authService.user?.imagePath ?? '',
                imageUrl: _authService.user?.imageUrl ?? '',
              ),
            ]),
        Teams(id: const Uuid().v4(), name: 'Orange Team', members: const []),
      ],
    );
    Get.toNamed(AppRoutes.challengeCreateTeam);
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
