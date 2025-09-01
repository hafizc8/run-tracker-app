import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/register_verify_email_controller.dart';

class RegisterVerifyEmailView extends GetView<RegisterVerifyEmailController> {
  const RegisterVerifyEmailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your email address',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 12.h),
              RichText(
                text: TextSpan(
                  text: 'We have sent a verification link to ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: controller.user?.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Click on the link to complete the verification process. You might need to check your spam folder.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 12.h),
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.canResend.value
                      ? () => controller.sendEmailVerify()
                      : null,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : controller.canResend.value
                          ? Text(
                              'Resend Email',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Text(
                              'Resend Email in ${controller.resendCooldown.value}s'),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
