import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordPasswordUpdatedView
    extends GetView<ForgotPasswordController> {
  const ForgotPasswordPasswordUpdatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/check_circle.svg',
                      width: 72.w,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Password Updated!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      'You\'re all set! Your new password is locked in and ready to go.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              GradientElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.login),
                child: Text(
                  'Back to Login',
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
