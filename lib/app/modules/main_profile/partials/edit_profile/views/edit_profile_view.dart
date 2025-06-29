import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/forms/update_user_form.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/edit_profile/controllers/edit_profile_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Edit Profile'),
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () {
            UpdateUserFormModel form = controller.form.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 398,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Visibility(
                          visible: form.image != null,
                          replacement:
                              Image.asset('assets/images/empty_profile.png'),
                          child: Image.file(form.image ?? File('')),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              onPressed: () => controller.imagePicker(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      initialValue: form.name,
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
                      'Email',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      readOnly: true,
                      initialValue: form.email,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(.2),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.3),
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      readOnly: true,
                      controller: controller.dateController,
                      onTap: () => controller.setDate(context),
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
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      readOnly: true,
                      initialValue: form.gender,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(.2),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(.3),
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
                      'Location',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.addressController,
                      cursorColor: Colors.white,
                      readOnly: true,
                      onTap: () async {
                        final res = await Get.toNamed(AppRoutes.chooseLocation,
                            arguments: {
                              'lat': form.latitude,
                              'lng': form.longitude,
                              'address': controller.addressController.text,
                            });
                        if (res != null) {
                          if (res['address'] != null &&
                              res['address'] is String) {
                            controller.addressController.text = res['address'];
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
                      decoration: const InputDecoration(
                        hintText: 'Choose your location',
                        suffixIcon: Icon(Icons.location_on),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bio',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      initialValue: form.bio,
                      maxLines: 3,
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          bio: value,
                          field: 'bio',
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your bio',
                        errorText: form.errors?['bio'],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ElevatedButton(
            onPressed: !controller.isValidToUpdate
                ? null
                : controller.isLoading.value
                    ? null
                    : () {
                        controller.updateProfile(context);
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
