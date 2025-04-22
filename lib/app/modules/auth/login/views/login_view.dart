import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/forms/login_form.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
              LoginFormModel form = controller.form.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
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
                        keyboardType: TextInputType.emailAddress,
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
                      Obx(
                        () => TextFormField(
                          cursorColor: Colors.black,
                          obscureText: controller.isVisiblePassword.value,
                          onChanged: (value) {
                            controller.form.value = form.copyWith(
                              password: value,
                              errors: form.errors,
                              field: 'password',
                            );
                          },
                          decoration: InputDecoration(
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
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
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
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.login(context),
                child: Visibility(
                  visible: controller.isLoading.value,
                  replacement: const Text('Login'),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'or login with',
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
              'Don\'t have account?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.register),
              child: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
