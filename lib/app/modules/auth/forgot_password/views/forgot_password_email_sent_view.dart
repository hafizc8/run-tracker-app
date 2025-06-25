import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordEmailSentView extends GetView<ForgotPasswordController> {
  const ForgotPasswordEmailSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/email_sent.svg', width: 72),
                  SizedBox(height: 24.h),
                  Text(
                    'Email Sent',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'We have sent your password reset link.\nYou might need to check your spam folder.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              GradientElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.login),
                child: Text(
                  'Back to Sign In',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
