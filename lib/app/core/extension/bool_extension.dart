import 'package:get/get_rx/src/rx_types/rx_types.dart';

extension RxBoolExtension on RxBool {
  void toggle() => value = !value;
}

extension BoolExtension on dynamic {
  String get toBool {
    switch (this) {
      case true:
        return '1';
      case false:
        return '0';
      case '1':
        return 'true';
      case '0':
        return 'false';
      case 1:
        return 'true';
      case 0:
        return 'false';
      default:
        return '0';
    }
  }
}
