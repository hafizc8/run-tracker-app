import 'package:get/get.dart';

class RegisterCreateProfileController extends GetxController {
  //TODO: Implement RegisterCreateProfileController

  final count = 0.obs;
  var selectedGender = 'Male'.obs;

  void changeGender(String gender) {
    selectedGender.value = gender;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
