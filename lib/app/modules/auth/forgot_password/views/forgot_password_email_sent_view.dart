import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordEmailSentView extends GetView<ForgotPasswordController> {
  const ForgotPasswordEmailSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/email_sent.svg', width: 72),
                    const SizedBox(height: 24),
                    Text(
                      'Email Sent',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'We have sent your password reset link.\nYou might need to check your spam folder.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.forgotPasswordSetNew),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}