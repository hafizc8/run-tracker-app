import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/social_page_enum.dart';

class SocialController extends GetxController {
  Rx<YourPageChip> selectedChip = YourPageChip.updates.obs;

  dynamic selectChip(YourPageChip chip) {
    selectedChip.value = chip;
  }
}
