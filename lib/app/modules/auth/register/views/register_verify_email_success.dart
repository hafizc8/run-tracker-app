import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/register_verify_email_success_controller.dart';

class RegisterVerifyEmailSuccessView
    extends GetView<RegisterVerifyEmailSuccessController> {
  const RegisterVerifyEmailSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/check_circle.svg',
                width: 72.w,
              ),
              SizedBox(height: 24.h),
              Text(
                'Email Verified',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 12.h),
              Text(
                'Your email has been verified. You can continue using the application.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Obx(
                () => Text(
                  'Redirecting you to the next page in ${controller.countDown.value}s',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.3),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
