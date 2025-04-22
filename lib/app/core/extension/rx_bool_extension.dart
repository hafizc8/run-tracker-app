import 'package:get/get_rx/src/rx_types/rx_types.dart';

extension RxBoolExtension on RxBool {
  void toggle() => value = !value;
}
