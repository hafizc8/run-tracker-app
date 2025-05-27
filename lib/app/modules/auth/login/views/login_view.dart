import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/login_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/step_tracker_widget.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Layer Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/z-background.png",
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                SvgPicture.asset(
                  'assets/images/zest-logo.svg',
                  height: 68,
                ),
                const SizedBox(height: 24),
                Obx(() {
                  LoginFormModel form = controller.form.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          GradientBorderTextField(
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              controller.form.value = form.copyWith(
                                email: value,
                                errors: form.errors,
                                field: 'email',
                              );
                            },
                            hintText: 'Enter your email',
                            errorText: form.errors?['email'],
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => GradientBorderTextField(
                              cursorColor: Colors.white,
                              obscureText: controller.isVisiblePassword.value,
                              onChanged: (value) {
                                controller.form.value = form.copyWith(
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
                              hintText: 'Enter your password',
                              errorText: form.errors?['password'],
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                Obx(
                  () => GradientElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.login(context),
                    child: Visibility(
                      visible: controller.isLoading.value,
                      replacement: Text(
                        'Login',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      child: CustomCircularProgressIndicator(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'or sign in with',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_google.svg',
                      width: 36,
                      colorFilter: const ColorFilter.mode(
                        Colors.white, // Warna yang diinginkan
                        BlendMode.srcIn, // BlendMode ini akan menerapkan warna ke SVG
                      ),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icons/ic_fb.svg',
                      width: 36,
                      colorFilter: const ColorFilter.mode(
                        Colors.white, // Warna yang diinginkan
                        BlendMode.srcIn, // BlendMode ini akan menerapkan warna ke SVG
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    children: <TextSpan>[
                      const TextSpan(text: 'Don\'t have account? '), // Tambahkan spasi di akhir
                      TextSpan(
                        text: 'Sign Up',
                        style: Theme.of(context).textTheme.headlineSmall,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.register);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
