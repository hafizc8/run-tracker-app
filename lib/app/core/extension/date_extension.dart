import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toYyyyMmDdString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toDDMMMyyyyString() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String toHumanPostDate() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'just now';
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
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
