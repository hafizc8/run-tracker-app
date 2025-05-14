import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/enums/club_post_permission_enum.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_club_form.dart';
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
        title: const Text('Create a Club'),
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
                        hintText: 'Enter club name',
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
                      'Description',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.black,
                      maxLines: 3,
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          description: value,
                          field: 'description',
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter club description',
                        errorText: form.errors?['description'],
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
                        color: Colors.grey.shade400,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.upload_outlined,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Upload Logo',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    (controller.isLoadingGetCurrentLocation.value)
                    ? const ShimmerLoadingList(itemCount: 1, itemHeight: 45, padding: EdgeInsets.all(0))
                    : TextFormField(
                      controller: controller.cityController,
                      cursorColor: Colors.black,
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
                      decoration: InputDecoration(
                        hintText: 'Choose your location',
                        suffixIcon: const Icon(Icons.location_on),
                        errorText: form.errors?['city'],
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    RadioListTile<ClubPrivacyEnum>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(ClubPrivacyEnum.public.name),
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
                      title: Text(ClubPrivacyEnum.private.name),
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    RadioListTile<ClubPostPermissionEnum>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(ClubPostPermissionEnum.onlyOwnerCanPost.name),
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
                      title: Text(ClubPostPermissionEnum.participantsCanPost.name),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                    ? null
                    : () {
                        controller.createClub(context);
                      },
            child: Visibility(
              visible: controller.isLoading.value,
              replacement: const Text('Create Club'),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}