import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/gender_enum.dart';
import 'package:zest_mobile/app/core/models/forms/registe_create_profile_form.dart';
import 'package:zest_mobile/app/modules/auth/register/controllers/register_create_profile_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RegisterCreateProfileView
    extends GetView<RegisterCreateProfileController> {
  const RegisterCreateProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Obx(() {
              RegisterCreateProfileFormModel form = controller.form.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create your profile',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          controller.form.value = form.copyWith(
                            name: value,
                            field: 'name',
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          errorText: form.errors?['name'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Birthday',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        cursorColor: Colors.black,
                        readOnly: true,
                        controller: controller.dateController,
                        onTap: () {
                          controller.setDate(context);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your birthday',
                          suffixIcon: const Icon(Icons.calendar_today),
                          errorText: form.errors?['birthday'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      RadioListTile<GenderEnum>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(GenderEnum.male.name),
                        value: GenderEnum.male,
                        groupValue: form.gender,
                        onChanged: (val) {
                          controller.form.value = form.copyWith(
                            gender: val,
                            field: 'gender',
                          );
                        },
                      ),
                      RadioListTile<GenderEnum>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(GenderEnum.female.name),
                        value: GenderEnum.female,
                        groupValue: form.gender,
                        onChanged: (val) {
                          controller.form.value = form.copyWith(
                            gender: val,
                            field: 'gender',
                          );
                        },
                      ),
                      RadioListTile<GenderEnum>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(GenderEnum.unknown.name),
                        value: GenderEnum.unknown,
                        groupValue: form.gender,
                        onChanged: (val) {
                          controller.form.value = form.copyWith(
                            gender: val,
                            field: 'gender',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        cursorColor: Colors.black,
                        readOnly: true,
                        onTap: () => Get.toNamed(
                            AppRoutes.registerCreateProfileChooseLocation),
                        decoration: const InputDecoration(
                          hintText: 'Choose your location',
                          suffixIcon: Icon(Icons.location_on),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            })
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ElevatedButton(
            onPressed: !controller.isValid
                ? null
                : controller.isLoading.value
                    ? null
                    : () {
                        controller.completeProfile(context);
                      },
            child: Visibility(
              visible: controller.isLoading.value,
              replacement: const Text('Continue'),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
