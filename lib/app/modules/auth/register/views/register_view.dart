import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/register_form.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
            child: SvgPicture.asset(
              "assets/images/z-background-full.svg",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                Image.asset(
                  'assets/images/zest-logo.png',
                  height: 48.h,
                ),
                SizedBox(height: 24.h),
                Obx(() {
                  RegisterFormModel form = controller.form.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Up',
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
                      SizedBox(height: 6.h),
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
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm Password',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(height: 6.h),
                          Obx(
                            () => GradientBorderTextField(
                              cursorColor: Colors.white,
                              obscureText: controller
                                  .isVisiblePasswordConfirmation.value,
                              onChanged: (value) {
                                controller.form.value = form.copyWith(
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
                              hintText: 'Confirm your password',
                              errorText: form.errors?['password_confirmation'],
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      CheckboxListTile(
                        value: form.isAgree,
                        onChanged: (val) {
                          controller.form.value = form.copyWith(
                            isAgree: val,
                            errors: form.errors,
                            field: 'is_agree',
                          );
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        isError: form.errors?['is_agree'] != null,
                        title: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              const TextSpan(
                                text:
                                    'By signing up, you acknowledge and agree to our ',
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: const TextStyle(
                                  color:
                                      Colors.blue, // make it look like a link
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed(AppRoutes.tnc),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Get.toNamed(AppRoutes.privacyPolicy),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (form.errors?['is_agree'] != null)
                        Text(
                          form.errors!['is_agree'],
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  );
                }),
                SizedBox(height: 16.h),
                Obx(
                  () => GradientElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.register(context);
                          },
                    child: Visibility(
                      visible: controller.isLoading.value,
                      replacement: Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      child: CustomCircularProgressIndicator(),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Or sign up with',
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
                  ],
                ),
                SizedBox(height: 24.h),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    children: <TextSpan>[
                      const TextSpan(text: 'Already have account? '),
                      TextSpan(
                        text: 'Sign in',
                        style: Theme.of(context).textTheme.headlineSmall,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.login);
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

class TextSpanWidget extends StatelessWidget {
  final String text;
  const TextSpanWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: lightColorScheme.primary,
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }
}
