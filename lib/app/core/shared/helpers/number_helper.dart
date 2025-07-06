import 'package:intl/intl.dart';

class NumberHelper {
  String formatNumberToK(num? number) {
    if (number == null) {
      return "0"; // Nilai default jika angka null
    }

    final formatter = NumberFormat("0.#", "id_ID");

    if (number.abs() < 1000) {
      return formatter.format(number);
    } else {
      // Untuk angka 1000 atau lebih besar (atau -1000 atau lebih kecil)
      double thousands = number.toDouble() / 1000.0;
      String formattedThousands = formatter.format(thousands);
      return '${formattedThousands}k';
    }
  }

  String formatDuration(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    if (hours > 0) {
      return "${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  String formatDistanceMeterToKm(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} m";
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return "${distanceInKm.toStringAsFixed(2)} km";
    }
  }

  // format number from 10000 to 10.000
  String formatNumberToKWithComma(num? number) {
    if (number == null) {
      return "0"; // Nilai default jika angka null
    }
    final formatter = NumberFormat("#,###", "id_ID");
    return formatter.format(number);
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount); // contoh: Rp 10.000
  }
}
