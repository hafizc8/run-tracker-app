import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/forgot_password_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Enter an email address that associated with your account and we will sent you instructions to reset your password.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          ForgotPasswordFormModel form = controller.form.value;
                          return GradientBorderTextField(
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              controller.form.value = form.copyWith(
                                email: value,
                                errors: form.errors,
                                field: 'email',
                              );
                            },
                            hintText: 'Enter Your Email',
                            errorText: form.errors?['email'],
                            textInputAction: TextInputAction.done,
                          );
                        })
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => GradientElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.forgotPassword(context);
                        },
                  child: Visibility(
                    visible: controller.isLoading.value,
                    replacement: const Text('Continue'),
                    child: CustomCircularProgressIndicator(),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFA2FF00),
                      Color(0xFF00FF7F),
                    ],
                  ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    'Back to Sign In',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
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
