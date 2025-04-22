import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toYyyyMmDdString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
