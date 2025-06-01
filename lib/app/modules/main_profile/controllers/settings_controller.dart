import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/shared/components/privacy_policy.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SettingsController extends GetxController {
  var isLoading = false.obs;
  var allowNotif = false.obs;
  var allowEmailnotif = false.obs;
  final _authService = sl<AuthService>();

  void logout() async {
    isLoading.value = true;
    try {
      bool resp = await _authService.logout();
      if (resp) Get.offAllNamed(AppRoutes.login);
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          surfaceTintColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <- atur radius di sini
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Logout",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  "Are you sure you want to logout?",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Obx(
                        () => SizedBox(
                          height: 55,
                          child: GradientElevatedButton(
                            onPressed: isLoading.value
                                ? null
                                : () {
                                    logout();
                                  },
                            child: Visibility(
                              visible: !isLoading.value,
                              replacement: const CircularProgressIndicator(),
                              child: const Text("Yes"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        height: 55,
                        child: GradientOutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (isLoading.value) return;
                            Get.back();
                          },
                          child: const Text("No, keep me here"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showNotifDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          surfaceTintColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <- atur radius di sini
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notification",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Allow Notification",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Switch(
                      thumbColor: MaterialStateProperty.all(Colors.white),
                      value: allowNotif.value,
                      onChanged: (value) {
                        allowNotif.toggle();
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Allow Email Notification",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Switch(
                      thumbColor: MaterialStateProperty.all(Colors.white),
                      value: allowEmailnotif.value,
                      onChanged: (value) {
                        allowEmailnotif.toggle();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 55,
                        child: GradientOutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: Text(
                            'Back',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        height: 55,
                        child: GradientElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Update"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: const PrivacyPolicyComponent(),
        );
      },
    );
  }
}
