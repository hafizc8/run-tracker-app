import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/forms/update_user_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/edit_profile/controllers/edit_profile_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
              ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
            color: Color(0xFFA5A5A5),
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
                Center(
                  child: SizedBox(
                    height: 110.h,
                    width: 110.w,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Visibility(
                            visible: form.image != null,
                            replacement:
                                Image.asset('assets/images/empty_profile.png'),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                form.image ?? File(''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -15,
                          child: GestureDetector(
                            onTap: () => controller.imagePicker(context),
                            child: Container(
                              width: 29.w,
                              height: 29.h,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/ic_edit_2.svg',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    GradientBorderTextField(
                      cursorColor: Colors.white,
                      controller: controller.nameController,
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          name: value,
                          field: 'name',
                        );
                      },
                      hintText: 'Enter your name',
                      errorText: form.errors?['name'],
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
                    GradientBorderTextField(
                      cursorColor: Colors.white,
                      readOnly: true,
                      controller: controller.dateController,
                      onTap: () => controller.setDate(context),
                      hintText: 'Enter your birthday',
                      suffixIcon: const Icon(Icons.calendar_today),
                      errorText: form.errors?['birthday'],
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
                    GradientBorderTextField(
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
                      hintText: 'Choose your location',
                      suffixIcon: const Icon(Icons.location_on),
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
                    GradientBorderTextField(
                      cursorColor: Colors.white,
                      controller: controller.bioController,
                      maxLines: 3,
                      minLines: 3,
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          bio: value,
                          field: 'bio',
                        );
                      },
                      hintText: 'Enter your bio',
                      errorText: form.errors?['bio'],
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
          () => SizedBox(
            height: 43.h,
            child: GradientElevatedButton(
              contentPadding: EdgeInsets.symmetric(vertical: 5.w),
              onPressed: !controller.isValidToUpdate
                  ? null
                  : controller.isLoading.value
                      ? null
                      : () {
                          controller.updateProfile(context);
                        },
              child: Visibility(
                visible: controller.isLoading.value,
                replacement: Text(
                  'Update',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
