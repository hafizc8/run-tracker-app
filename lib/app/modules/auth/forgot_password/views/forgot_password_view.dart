import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // vertical center
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/ic_forget_password.png', height: 280.h),
              SizedBox(height: 24.h),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'Enter an email address that associated with your account and we will sent you instructions to reset your password.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 18.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 6.h),
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
              SizedBox(height: 24.h),
              Obx(
                () => GradientElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.forgotPassword(context);
                        },
                  child: Visibility(
                    visible: controller.isLoading.value,
                    replacement: Text(
                      'Continue',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    child: CustomCircularProgressIndicator(),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
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
