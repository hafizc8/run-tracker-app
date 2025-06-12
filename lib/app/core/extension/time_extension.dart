import 'package:flutter/material.dart';

extension TimeOfDayExtension on String {
  /// Format yang didukung: "HH:mm", misalnya "14:30"

  TimeOfDay? toTimeOfDay() {
    if (isEmpty) {
      return null;
    }
    final parts = split(':');
    if (parts.length < 2) {
      throw const FormatException(
          'Format waktu tidak valid. Gunakan "HH:mm" atau "HH:mm:ss"');
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw const FormatException('Jam atau menit tidak valid');
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}
