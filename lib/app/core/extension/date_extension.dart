import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toYyyyMmDdString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toYyyyMmDdHisString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }

  String toddMMMyyyy() {
    return DateFormat("dd MMMM yyyy").format(this);
  }

  String toDDMMMyyyyString() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String todMMMyyyyString() {
    return DateFormat('d MMM yyyy').format(this);
  }

  String todMMMString() {
    return DateFormat('d MMM').format(this);
  }

  String toEEEddMMMyyyy() {
    return DateFormat('EEE, dd MMM yyyy').format(this);
  }

  String toMMMddyyyyhhmmaString() {
    return DateFormat("MMM, dd yyyy hh:mm a").format(this);
  }

  String toHumanPostDate() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'just now';
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }
    if (difference.inDays == 1) {
      return 'yesterday';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }

    // Tampilkan dalam format tanggal: 7 May 2025
    return DateFormat('d MMM yyyy').format(this);
  }
}

extension DateTimeExtensions on DateTime {
  bool isDateTimePassed(TimeOfDay time) {
    final combinedDateTime = DateTime(
      year,
      month,
      day,
      time.hour,
      time.minute,
    );

    return combinedDateTime.isAfter(DateTime.now());
  }

  bool isFutureDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(year, month, day);
    return dateOnly.isAfter(today);
  }
}
