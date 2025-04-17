import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/register_form.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Placeholder(
              fallbackHeight: 200,
              fallbackWidth: 200,
              child: Text('Logo'),
            ),
            const SizedBox(height: 24),
            Obx(() {
              RegisterFormModel form = controller.form.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          controller.form.value = form.copyWith(
                            email: value,
                            errors: form.errors,
                            field: 'email',
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          errorText: form.errors?['email'],
                        ),
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
                      TextFormField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          controller.form.value = form.copyWith(
                            password: value,
                            errors: form.errors,
                            field: 'password',
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          errorText: form.errors?['password'],
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          controller.form.value = form.copyWith(
                            passwordConfirmation: value,
                            errors: form.errors,
                            field: 'password_confirmation',
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          errorText: form.errors?['password_confirmation'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: form.isAgree,
                        onChanged: (val) {},
                        isError: true,
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              'By signing up, you acknowledge and agree to our ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const TextSpanWidget('Terms & Conditions'),
                            Text(
                              ' and ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const TextSpanWidget('Privacy Policy'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (form.errors?['is_agree'] != null)
                    Text(
                      form.errors!['is_agree'],
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              );
            }),
            const SizedBox(height: 16),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.register();
                      },
                child: Visibility(
                  visible: controller.isLoading.value,
                  replacement: const Text('Create Account'),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'or sign up with',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/ic_google.svg', width: 36),
                const SizedBox(width: 20),
                SvgPicture.asset('assets/icons/ic_fb.svg', width: 36),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'already have account?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextSpanWidget extends StatelessWidget {
  final String text;
  const TextSpanWidget(this.text, {Key? key}) : super(key: key);

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
