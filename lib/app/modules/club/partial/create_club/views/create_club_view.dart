import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/enums/club_post_permission_enum.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_club_form.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/club/partial/create_club/controllers/create_club_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class CreateClubView extends GetView<CreateClubController> {
  const CreateClubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Create a Club',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () {
            CreateClubFormModel form = controller.form.value;

            print('form.errors: ${form.errors}');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Club Name',
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
                        hintText: 'Enter club name',
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
                      'Description',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      maxLines: 3,
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          description: value,
                          field: 'description',
                        );
                      },
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                      decoration: InputDecoration(
                        hintText: 'Enter club description',
                        errorText: form.errors?['description'],
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
                // preview selected image
                if (form.image != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(
                        form.image!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    controller.pickImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_outlined,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Upload Logo',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
                  ),
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
                    (controller.isLoadingGetCurrentLocation.value)
                    ? const Center(child: CircularProgressIndicator())
                    : TextFormField(
                      controller: controller.cityController,
                      cursorColor: Colors.white,
                      readOnly: true,
                      onTap: () async {
                        final res = await Get.toNamed(AppRoutes.chooseLocation,
                            arguments: {
                              'lat': form.latitude,
                              'lng': form.longitude,
                              'address': form.address,
                            });

                        if (res != null) {
                          if (res['address'] != null && res['address'] is String) {
                            controller.form.value = form.copyWith(address: res['address']);
                          }

                          if (res['location'] != null && res['location'] is LatLng) {
                            controller.form.value = form.copyWith(
                              latitude: res['location'].latitude,
                              longitude: res['location'].longitude,
                            );

                            await controller.getOnlyCity(latLng: res['location']);
                          }
                        }
                      },
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                      decoration: InputDecoration(
                        hintText: 'Choose your location',
                        suffixIcon: const Icon(Icons.location_on),
                        errorText: form.errors?['city'],
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
                      'Privacy',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    RadioListTile<ClubPrivacyEnum>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        ClubPrivacyEnum.public.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      value: ClubPrivacyEnum.public,
                      groupValue: form.clubPrivacy,
                      onChanged: (val) {
                        controller.form.value = form.copyWith(
                          clubPrivacy: val,
                          field: 'privacy',
                        );
                      },
                    ),
                    RadioListTile<ClubPrivacyEnum>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        ClubPrivacyEnum.private.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      value: ClubPrivacyEnum.private,
                      groupValue: form.clubPrivacy,
                      onChanged: (val) {
                        controller.form.value = form.copyWith(
                          clubPrivacy: val,
                          field: 'privacy',
                        );
                      },
                    ),
                    (form.errors?['privacy'] != null)
                        ? Text(
                            form.errors?['privacy'],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    RadioListTile<ClubPostPermissionEnum>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        ClubPostPermissionEnum.onlyOwnerCanPost.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      value: ClubPostPermissionEnum.onlyOwnerCanPost,
                      groupValue: form.postPermission,
                      onChanged: (val) {
                        controller.form.value = form.copyWith(
                          postPermission: val,
                          field: 'post_permission',
                        );
                      },
                    ),
                    RadioListTile<ClubPostPermissionEnum>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        ClubPostPermissionEnum.participantsCanPost.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                      value: ClubPostPermissionEnum.participantsCanPost,
                      groupValue: form.postPermission,
                      onChanged: (val) {
                        controller.form.value = form.copyWith(
                          postPermission: val,
                          field: 'post_permission',
                        );
                      },
                    ),
                    (form.errors?['post_permission'] != null)
                        ? Text(
                            form.errors?['post_permission'],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 55,
          child: GradientElevatedButton(
            onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.createClub(context);
                      },
            child: Visibility(
              visible: controller.isLoading.value,
              replacement: Text(
                'Create Club',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}