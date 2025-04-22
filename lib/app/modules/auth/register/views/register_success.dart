import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RegisterSuccessView extends StatelessWidget {
  const RegisterSuccessView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You\'re In!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to the squad! Time to move, earn rewards, and have some fun.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.mainHome),
                child: const Text('Let’s Go!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
