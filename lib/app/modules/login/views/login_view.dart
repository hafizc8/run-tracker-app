import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/core/theme/color_schemes.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

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
            Form(
              child: Column(
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
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
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
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Login'),
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
