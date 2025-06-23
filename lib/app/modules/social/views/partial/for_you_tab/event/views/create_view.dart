import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/forms/store_event_form.dart';
import 'package:zest_mobile/app/core/models/model/club_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/event_activity_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_chip.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/event_action_controller.dart';

class EventCreateView extends GetView<EventActionController> {
  const EventCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        controller.resetForm();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${controller.isEdit.value ? 'Edit' : 'Create'} an Events',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFA5A5A5),
                ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 4,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.chevron_left,
              size: 48,
              color: Color(0xFFA5A5A5),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            EventStoreFormModel form = controller.form.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => DropdownButtonFormField<EventActivityModel>(
                        decoration: InputDecoration(
                          labelText: 'Choose activity',
                          errorText: form.errors?['activity'],
                        ),
                        value: form.activity,
                        items: controller.eventActivities
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label ?? '-'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.form.value = form.copyWith(
                            activity: value,
                            errors: form.errors,
                            field: 'activity',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      initialValue: form.title,
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          title: value,
                          errors: form.errors,
                          field: 'title',
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Title',
                        errorText: form.errors?['title'],
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
                      'Description',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      maxLines: 3,
                      initialValue: form.description,
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          description: value,
                          field: 'description',
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter event description',
                        errorText: form.errors?['description'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      cursorColor: Colors.white,
                      readOnly: true,
                      controller: controller.imageController,
                      onTap: () => controller.imagePicker(context),
                      decoration: InputDecoration(
                        hintText: 'Upload Image (Optional)',
                        prefixIcon: const Icon(Icons.file_upload_outlined),
                        errorText: form.errors?['image'],
                      ),
                    ),
                    if (form.image != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            form.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.placeNameController,
                      cursorColor: Colors.white,
                      readOnly: true,
                      onTap: () async {
                        final res = await Get.toNamed(
                          AppRoutes.chooseLocationEvent,
                          arguments: {
                            'lat': form.latitude,
                            'lng': form.longitude,
                            'address': controller.addressController.text,
                            'placeName': controller.placeNameController.text,
                          },
                        );
                        if (res != null) {
                          if (res['placeName'] != null &&
                              res['placeName'] is String) {
                            controller.form.value = form.copyWith(
                              placeName: res['placeName'],
                            );

                            controller.placeNameController.text =
                                res['placeName'];
                          }
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
                      decoration: InputDecoration(
                        hintText: 'Choose location',
                        suffixIcon: const Icon(Icons.location_on),
                        errorText: (form.errors?['latitude'] != null &&
                                form.errors?['longitude'] != null)
                            ? "The location field is required"
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      readOnly: true,
                      controller: controller.dateController,
                      onTap: () => controller.setDate(context),
                      decoration: InputDecoration(
                        hintText: 'Choose date & time',
                        suffixIcon: const Icon(Icons.calendar_today),
                        errorText: form.errors?['date'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Htm',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      initialValue: (form.price == null || form.price == 0)
                          ? ''
                          : form.price.toString(),
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          price: int.parse(value),
                          errors: form.errors,
                          field: 'price',
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Htm',
                        errorText: form.errors?['price'],
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
                      'Quota',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      initialValue: (form.quota ?? '').toString(),
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          quota: int.parse(value),
                          errors: form.errors,
                          field: 'quota',
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Quota',
                        errorText: form.errors?['quota'],
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Event Publications',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Set event to private",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: Switch(
                    value: !(form.isPublic ?? false),
                    thumbColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    onChanged: (value) {
                      controller.form.value = form.copyWith(
                        isPublic: !value,
                        errors: form.errors,
                        field: 'is_public',
                      );
                    },
                  ),
                ),
                if (form.errors?['is_public'] != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      form.errors?['is_public'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                if (!controller.isEdit.value) ...[
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Automatically post this event to the club",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Switch(
                      value: form.isAutoPostToClub ?? false,
                      thumbColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      onChanged: (value) {
                        controller.form.value = form.copyWith(
                          isAutoPostToClub: value,
                          errors: form.errors,
                          field: 'is_auto_post_to_club',
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: form.errors?['is_auto_post_to_club'] != null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        form.errors?['is_auto_post_to_club'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (form.isAutoPostToClub ?? false) ...[
                    Obx(() {
                      final clubs = controller.form.value.shareToClubs;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...(clubs ?? []).map(
                            (club) => CustomChip(
                              border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      club.name ?? '-',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final List<ClubMiniModel> updateClubs =
                                          List.from(clubs ?? []);
                                      updateClubs.remove(club);
                                      controller.form.value = form.copyWith(
                                        shareToClubs: updateClubs,
                                        isAutoPostToClub:
                                            (form.isAutoPostToClub ?? false)
                                                ? updateClubs.isNotEmpty
                                                : false,
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete_forever,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          CustomChip(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onTap: () {
                              controller.showAddClubsDialog();
                              if (controller.eventClubs.isEmpty) {
                                controller.getClubs();
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                Text(
                                  'Add  Club',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ]
                ]
              ],
            );
          }),
        ),
        bottomNavigationBar: Obx(() {
          if (controller.isEdit.value) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 55,
              child: GradientElevatedButton(
                onPressed:
                    !controller.isValidToUpdate || controller.isLoading.value
                        ? null
                        : () {
                            controller.updateEvent();
                          },
                child: Visibility(
                  visible: controller.isLoading.value,
                  replacement: const Text('Update'),
                  child: CustomCircularProgressIndicator(),
                ),
              ),
            );
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            height: 55,
            child: GradientElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      controller.storeEvent();
                    },
              child: Visibility(
                visible: controller.isLoading.value,
                replacement: const Text('Create Event'),
                child: CustomCircularProgressIndicator(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
