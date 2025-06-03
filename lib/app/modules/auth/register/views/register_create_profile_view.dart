import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/enums/gender_enum.dart';
import 'package:zest_mobile/app/core/models/forms/registe_create_profile_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/modules/auth/register/controllers/register_create_profile_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class RegisterCreateProfileView
    extends GetView<RegisterCreateProfileController> {
  const RegisterCreateProfileView({super.key});

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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        cursorColor: Colors.white,
                        onChanged: (value) {
                          controller.form.value = form.copyWith(
                            name: value,
                            field: 'name',
                          );
                        },
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          errorText: form.errors?['name'],
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        cursorColor: Colors.white,
                        readOnly: true,
                        controller: controller.dateController,
                        onTap: () {
                          controller.setDate(context);
                        },
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                        decoration: InputDecoration(
                          hintText: 'Enter your birthday',
                          suffixIcon: const Icon(Icons.calendar_today),
                          errorText: form.errors?['birthday'],
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      RadioListTile<GenderEnum>(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          GenderEnum.male.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                        ),
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
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          GenderEnum.female.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                        ),
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
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          GenderEnum.unknown.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                        ),
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.addressController,
                        cursorColor: Colors.white,
                        readOnly: true,
                        onTap: () async {
                          final res = await Get.toNamed(
                              AppRoutes.chooseLocation,
                              arguments: {
                                'lat': form.latitude,
                                'lng': form.longitude,
                                'address': controller.addressController.text,
                              });
                          if (res != null) {
                            if (res['address'] != null &&
                                res['address'] is String) {
                              controller.addressController.text =
                                  res['address'];
                            }

                            if (res['location'] != null &&
                                res['location'] is LatLng) {
                              controller.form.value = form.copyWith(
                                latitude: res['location'].latitude,
                                longitude: res['location'].longitude,
                              );
                            }
                          }
                        },
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                        decoration: InputDecoration(
                          hintText: 'Choose your location',
                          suffixIcon: const Icon(Icons.location_on),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
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
      bottomNavigationBar: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Obx(
          () => GradientElevatedButton(
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
              child: CustomCircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
