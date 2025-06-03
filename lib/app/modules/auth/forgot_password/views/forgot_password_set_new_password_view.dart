import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    const SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Password',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        GradientBorderTextField(
                          cursorColor: Colors.black,
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
                        const SizedBox(height: 16),
                        Text(
                          'Confirm Password',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        GradientBorderTextField(
                          cursorColor: Colors.black,
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
              const SizedBox(height: 24),
              Obx(
                () => GradientElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.resetPassword(context);
                        },
                  child: Visibility(
                    visible: controller.isLoading.value,
                    replacement: const Text('Update Password'),
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
