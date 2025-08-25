import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/login_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                SvgPicture.asset(
                  'assets/images/zest-logo.svg',
                  height: 68,
                ),
                SizedBox(height: 24.h),
                Obx(() {
                  LoginFormModel form = controller.form.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 6.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 6.h),
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
                      SizedBox(height: 10.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 6.h),
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
                SizedBox(height: 17.h),
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
                SizedBox(height: 31.h),
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
                SizedBox(height: 20.h),
                Text(
                  'or sign in with',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Visibility(
                        visible: controller.isLoadingGoogle.value,
                        replacement: InkWell(
                          onTap: () => controller.loginWithGoogle(),
                          child: SvgPicture.asset(
                            'assets/icons/ic_google.svg',
                            width: 36.w,
                            colorFilter: const ColorFilter.mode(
                              Colors.white, // Warna yang diinginkan
                              BlendMode
                                  .srcIn, // BlendMode ini akan menerapkan warna ke SVG
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomCircularProgressIndicator(),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    SvgPicture.asset(
                      'assets/icons/ic_fb.svg',
                      width: 36.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white, // Warna yang diinginkan
                        BlendMode
                            .srcIn, // BlendMode ini akan menerapkan warna ke SVG
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    children: <TextSpan>[
                      const TextSpan(
                          text:
                              'Don\'t have account? '), // Tambahkan spasi di akhir
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
