import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/reset_password_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordSetNewPasswordView
    extends GetView<ForgotPasswordController> {
  const ForgotPasswordSetNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // vertical center
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                ResetPasswordFormModel form = controller.formReset.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Your New Password',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 18.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Password',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 12.h),
                        GradientBorderTextField(
                          cursorColor: Colors.white,
                          obscureText: controller.isVisiblePassword.value,
                          onChanged: (value) {
                            controller.formReset.value = form.copyWith(
                              password: value,
                              errors: form.errors,
                              field: 'password',
                            );
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isVisiblePassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                controller.isVisiblePassword.toggle(),
                          ),
                          hintText: 'Enter your new password',
                          errorText: form.errors?['password'],
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Confirm Password',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 12.h),
                        GradientBorderTextField(
                          cursorColor: Colors.white,
                          obscureText:
                              controller.isVisiblePasswordConfirmation.value,
                          onChanged: (value) {
                            controller.formReset.value = form.copyWith(
                              passwordConfirmation: value,
                              errors: form.errors,
                              field: 'password_confirmation',
                            );
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isVisiblePasswordConfirmation.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => controller
                                .isVisiblePasswordConfirmation
                                .toggle(),
                          ),
                          hintText: 'Confirm your new password',
                          errorText: form.errors?['password_confirmation'],
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ],
                );
              }),
              SizedBox(height: 24.h),
              Obx(
                () => GradientElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.resetPassword(context);
                        },
                  child: Visibility(
                    visible: controller.isLoading.value,
                    replacement: Text(
                      'Update Password',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    child: CustomCircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
