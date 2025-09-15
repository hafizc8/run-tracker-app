import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';

import 'package:zest_mobile/app/core/models/forms/edit_challenge_form.dart';
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
  final TextEditingController targetController = TextEditingController();
  var isLoading = false.obs;
  var isLoadingTeams = false.obs;

  var form = EditChallengeFormModel().obs;
  var formOriginal = EditChallengeFormModel().obs;

  bool get isEdited => formOriginal.value.isValidToUpdate(form.value);

  final _authService = sl<AuthService>();
  final _challengeService = sl<ChallengeService>();
  String get userId => _authService.user?.id ?? ''; // userId
  String challengeId = '';
  ChallengeDetailModel? challengeDetail;

  var isTeamView = false;

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

    targetController.text = CurrencyTextInputFormatter.currency(
      locale: "id_ID",
      symbol: '',
      decimalDigits: 0,
    )
        .formatEditUpdate(
          const TextEditingValue(text: '0'),
          TextEditingValue(text: (challenge.target ?? 0).toString()),
        )
        .text;
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
        form.value.copyWith(
            target: int.tryParse(targetController.text.replaceAll('.', ''))),
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
        if (isTeamView) Get.back();
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
    if (name == null || name.trim().isEmpty) return;

    final teams = form.value.teams ?? [];
    final currentTeam = teams[index];
    final oldName = currentTeam.name;

    final lowerName = name.toLowerCase().trim();

    // Validasi duplikat (abaikan dirinya sendiri)
    final nameExists = teams
        .where((t) => t != currentTeam)
        .any((t) => t.name?.toLowerCase().trim() == lowerName);

    if (nameExists) {
      Get.snackbar(
        'Error',
        'Team name "$name" already exists',
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }

    // === PENENTUAN: tim baru atau lama ===
    final isNewTeam = currentTeam.id == null ||
        (form.value.newTeams?.contains(oldName) ?? false);

    // Tim Baru → Update newTeams
    if (isNewTeam) {
      // Replace nama lama di newTeams
      List<String>? currentNewTeams = [...(form.value.newTeams ?? [])];
      final indexInNew = currentNewTeams.indexWhere(
        (t) => t.toLowerCase().trim() == oldName?.toLowerCase().trim(),
      );

      if (indexInNew != -1) {
        currentNewTeams[indexInNew] = name;
      }

      form.value = form.value.copyWith(newTeams: currentNewTeams);
    } else {
      // Tim Lama → Tambah atau update di renameTeams
      if (oldName != null && oldName != name) {
        List<RenameTeam>? currentRename = [...(form.value.renameTeams ?? [])];

        final indexRename =
            currentRename.indexWhere((r) => r.newName == oldName);

        if (indexRename != -1) {
          // Sudah pernah di-rename → update newName
          currentRename[indexRename] =
              currentRename[indexRename].copyWith(newName: name);
        } else {
          // Belum pernah di-rename → tambah entri baru
          currentRename.add(RenameTeam(oldName: oldName, newName: name));
        }

        form.value = form.value.copyWith(renameTeams: currentRename);
      }
    }

    // Update tim di list
    final updatedTeam = currentTeam.copyWith(name: name, isEdit: false);
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
    final teamToDelete = currentTeams[index];
    final teamName = teamToDelete.name;

    // Apakah tim ini tim baru? (tidak punya ID atau berasal dari newTeams)
    final isNewTeam = teamToDelete.id == null ||
        (form.value.newTeams?.contains(teamName) ?? false);

    // Hapus dari teams list
    final updatedTeams = [...currentTeams]..removeAt(index);

    // Jika tim baru → juga hapus dari newTeams
    List<String>? updatedNewTeams = form.value.newTeams;
    if (isNewTeam && teamName != null) {
      updatedNewTeams = [...(form.value.newTeams ?? [])]..removeWhere(
          (t) => t.toLowerCase().trim() == teamName.toLowerCase().trim());
    }

    // Jika tim dari server → tambahkan ke deleteTeams
    List<String>? updatedDeleteTeams = form.value.deleteTeams;
    if (!isNewTeam && teamName != null) {
      updatedDeleteTeams = [...(form.value.deleteTeams ?? []), teamName];
    }

    // Update form
    form.value = form.value.copyWith(
      teams: updatedTeams,
      newTeams: updatedNewTeams,
      deleteTeams: updatedDeleteTeams,
    );
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

    final newTeamName = 'New Team ${(form.value.teams?.length ?? 0) + 1}';

    if (form.value.teams
            ?.any((t) => t.name?.toLowerCase() == newTeamName.toLowerCase()) ??
        false) {
      Get.snackbar(
        'Error',
        'Team name "$newTeamName" already exists',
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
      );
      return;
    }
    final newTeam =
        Teams(id: const Uuid().v4(), name: newTeamName, members: const []);

    List<Teams>? updatedTeams = [...(form.value.teams ?? []), newTeam];
    List<String>? updatedNewTeams = [
      ...(form.value.newTeams ?? []),
      newTeamName
    ];

    form.value = form.value.copyWith(
      teams: updatedTeams,
      newTeams: updatedNewTeams,
    );
  }
}
