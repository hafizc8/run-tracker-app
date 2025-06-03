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
}