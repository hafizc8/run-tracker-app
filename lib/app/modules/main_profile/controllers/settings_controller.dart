import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SettingsController extends GetxController {
  var isLoading = false.obs;
  var allowNotif = false.obs;
  var allowEmailnotif = false.obs;
  Rx<String?> appVersion = Rx(null);
  final _authService = sl<AuthService>();

  @override
  void onInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appVersion
      ..value = packageInfo.version
      ..refresh();
    super.onInit();
  }

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
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          insetPadding: EdgeInsets.all(32.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(2.w),
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 24.h,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Align(
                    alignment: Alignment.topLeft,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFA2FF00),
                          Color(0xFF00FF7F),
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Are you sure you want to sign out?',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  SizedBox(height: 30.h),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 43.h,
                          child: GradientOutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: Obx(
                              () => Visibility(
                                visible: !isLoading.value,
                                replacement: CustomCircularProgressIndicator(),
                                child: Text(
                                  'Yes',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                            ),
                            onPressed: () => logout(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 43.h,
                          child: GradientElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.zero,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () => Get.back(),
                            child: Text(
                              'No, keep me here',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showNotifDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notification",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            SizedBox(height: 16.h),
            Obx(
              () => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Allow Notification",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
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
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
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
            SizedBox(height: 16.h),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 43.h,
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
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 43.h,
                    child: GradientElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Update",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
