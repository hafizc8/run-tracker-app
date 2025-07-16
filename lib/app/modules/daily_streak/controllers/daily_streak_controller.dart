import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyStreakController extends GetxController {
  // State untuk mengontrol hari yang sedang ditampilkan di kalender
  var focusedDay = DateTime.now().obs;
  // State untuk hari yang dipilih oleh pengguna (Rx<DateTime?> agar bisa null)
  var selectedDay = Rx<DateTime?>(null);

  // CONTOH DATA: Nanti Anda akan mengisi ini dari data asli (misal: dari API)
  // Dibuat .obs agar UI bisa bereaksi jika data ini berubah.
  var streakDays = <int>{1, 2, 4, 5, 8, 9, 11, 13, 14, 16, 17, 19, 21}.obs;

  // Method untuk menangani saat pengguna memilih tanggal
  void onDaySelected(DateTime selected, DateTime focused) {
    // Jika pengguna menekan tanggal yang sudah dipilih, batalkan pilihan.
    if (isSameDay(selectedDay.value, selected)) {
      selectedDay.value = null;
    } else {
      selectedDay.value = selected;
      focusedDay.value = focused;
    }
  }

  // Method untuk menangani saat pengguna menggeser bulan
  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
  }
}