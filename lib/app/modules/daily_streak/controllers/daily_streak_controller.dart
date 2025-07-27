import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/daily_record_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/services/record_activity_service.dart';

class DailyStreakController extends GetxController {
  // --- DEPENDENCIES ---
  final _recordActivityService = sl<RecordActivityService>();
  final _logService = sl<LogService>();
  final _authService = sl<AuthService>();
  UserModel? get user => _authService.user;

  // --- STATE ---
  var isInitialLoading = true.obs;
  var isPageLoading = false.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = Rx<DateTime?>(null);

  // ✨ State untuk menampung data dari API
  var dailyRecords = <DailyRecordModel>[].obs;
  var streakDays = <int>{}.obs;

  // ✨ State untuk menampilkan detail XP dari tanggal yang dipilih
  var selectedRecord = Rx<DailyRecordModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Panggil fetch data untuk bulan saat ini saat controller pertama kali dimuat
    fetchDailyRecords(focusedDay.value, isInitialLoad: true);
    _loadMe();
  }

  Future<void> _loadMe() async {
    try {
      await _authService.me();
    } catch (e) {
      rethrow;
    }
  }

  /// ✨ KUNCI #1: Mengambil data dari service
  Future<void> fetchDailyRecords(DateTime date, {bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      isInitialLoading.value = true;
    } else {
      isPageLoading.value = true;
    }

    try {
      // Format tanggal menjadi "yyyy-MM" untuk parameter API
      final monthYear = DateFormat('yyyy-MM').format(date);
      _logService.log.i("Fetching daily records for: $monthYear");
      
      final records = await _recordActivityService.getDailyRecord(yearMonth: monthYear);
      dailyRecords.assignAll(records.data);

      // ✨ KUNCI #3: Mengumpulkan tanggal yang memiliki streak
      final newStreakDays = <int>{};
      for (var record in records.data) {
        if ((record.streak ?? 0) > 0 && record.date != null) {
          newStreakDays.add(record.date!.day);
        }
      }
      streakDays.clear();
      streakDays.addAll(newStreakDays);

      selectedDay.value = null;
      selectedRecord.value = null;

      _logService.log.i("Streak days for this month: $streakDays");

      // Reset pilihan saat data baru dimuat
      selectedDay.value = null;
      selectedRecord.value = null;

      // set onDaySelected ke hari ini
      onDaySelected(DateTime.now(), DateTime.now());

    } catch (e, s) {
      _logService.log.e("Failed to fetch daily records", error: e, stackTrace: s);
      Get.snackbar("Error", "Could not load streak data.");
    } finally {
      isInitialLoading.value = false;
      isPageLoading.value = false;
    }
  }

  /// ✨ KUNCI #4: Menampilkan data detail saat tanggal dipilih
  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
    // Cari data record yang cocok dengan tanggal yang dipilih
    final record = dailyRecords.firstWhere(
      (r) => isSameDay(r.date, selected),
      orElse: () => DailyRecordModel(), // Kembalikan model kosong jika tidak ditemukan
    );
    selectedRecord.value = record;
  }

  /// ✨ KUNCI #2: Fetch data baru saat bulan diganti
  void onPageChanged(DateTime focused) {
    // Jangan fetch jika bulan tidak berubah
    if (focusedDay.value.month == focused.month && focusedDay.value.year == focused.year) {
      focusedDay.value = focused;
      return;
    }
    focusedDay.value = focused;
    // Panggil API untuk bulan yang baru, tandai bukan sebagai initial load
    fetchDailyRecords(focused);
  }
}