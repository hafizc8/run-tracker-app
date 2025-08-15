import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';

class DateHelper {
  static Future<DateTime?> setDate(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  static String formatChatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.isAtSameMomentAs(today)) {
      return "Today";
    } else if (date.isAtSameMomentAs(yesterday)) {
      return "Yesterday";
    } else {
      return date.toEEEddMMMyyyy();
    }
  }
}
