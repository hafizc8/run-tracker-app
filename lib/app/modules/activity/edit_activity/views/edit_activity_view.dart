import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/forms/edit_activity_form.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_dialog_confirmation.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/activity/edit_activity/controllers/edit_activity_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/media_preview_edit.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EditActivityView extends GetView<EditActivityController> {
  const EditActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.dialog(
          CustomDialogConfirmation(
            title: 'Delete Activity',
            subtitle: 'This will permanently delete your session history. Are you sure?',
            labelConfirm: 'Yes, delete',
            onConfirm: () {
              Get.offAllNamed(AppRoutes.mainHome);
              Get.snackbar('Success', 'Successfully delete activity');
            },
            onCancel: () => Get.back(),
          )
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Edit Activity'),
          automaticallyImplyLeading: false,
          elevation: 1,
          leading: null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(
            () {
              if (controller.isLoadingLoadEditActivity.value) {
                return const ShimmerLoadingList(
                  itemCount: 10,
                  itemHeight: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                );
              }
      
              EditActivityForm form = controller.editActivityForm.value;
              print(form.errors?['content']);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: Colors.white,
                    initialValue: form.title,
                    onChanged: (value) {
                      controller.editActivityForm.value = form.copyWith(
                        title: value,
                        field: 'title',
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      errorText: form.errors?['title'],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: Colors.white,
                    initialValue: form.content,
                    onChanged: (value) {
                      controller.editActivityForm.value = form.copyWith(
                        content: value,
                        field: 'content',
                      );
                    },
                    maxLines: 3,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter Content',
                      errorText: form.errors?['content'],
                    ),
                  ),
                  const SizedBox(height: 12),
                  (form.newGalleries ?? []).isNotEmpty
                      ? MediaPreviewEdit(
                          currentGalleries: form.currentGalleries ?? [],
                          newGalleries: form.newGalleries ?? [],
                          onRemove: (int index, bool isFromServer,
                              Gallery? gallery, File? file) {
                            controller.removeMedia(
                              isFromServer: isFromServer,
                              gallery: gallery,
                              file: file,
                            );
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      controller.pickMultipleMedia();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.upload_outlined,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Upload Image',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 310,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-6.2615, 106.8106),
                        zoom: 16,
                      ),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                      polylines: controller.activityPolylines,
                      onMapCreated: controller.onMapCreated,
                      mapType: MapType.normal,
                      markers: {
                        if (controller.currentPath.isNotEmpty) ...[
                          Marker(
                            markerId: const MarkerId('start_point'),
                            position: LatLng(
                              controller.currentPath.first.latitude,
                              controller.currentPath.first.longitude,
                            ),
                            icon: controller.startIcon,
                            // ✨ Sesuaikan anchor agar ujung pin pas di garis ✨
                            anchor: const Offset(0.5, 1.0), 
                          ),
                          if (controller.currentPath.length > 1)
                            Marker(
                              markerId: const MarkerId('end_point'),
                              position: LatLng(
                                controller.currentPath.last.latitude,
                                controller.currentPath.last.longitude,
                              ),
                              icon: controller.endIcon,
                              // ✨ Sesuaikan anchor agar ujung pin pas di garis ✨
                              anchor: const Offset(0.5, 1.0),
                            ),
                        ]
                      }
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (controller.isLoadingSaveRecordActivity.value) {
                      return const SizedBox();
                    }
                    return Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      height: 55,
                      child: GradientOutlinedButton(
                        onPressed: () {
                          Get.dialog(
                            CustomDialogConfirmation(
                              title: 'Delete Activity',
                              subtitle: 'This will permanently delete your session history. Are you sure?',
                              labelConfirm: 'Yes, delete',
                              onConfirm: () {
                                Get.offAllNamed(AppRoutes.mainHome);
                                Get.snackbar('Success', 'Successfully delete activity');
                              },
                              onCancel: () => Get.back(),
                            )
                          );
                        },
                        child: const Text('Delete'),
                      ),
                    );
                  }),
                  Obx(() {
                    return Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      height: 55,
                      child: GradientElevatedButton(
                        onPressed: controller.isLoadingSaveRecordActivity.value
                            ? null
                            : () {
                                controller.saveActivity();
                              },
                        child: Visibility(
                          visible: controller.isLoadingSaveRecordActivity.value,
                          replacement: const Text('Share Activity'),
                          child: CustomCircularProgressIndicator(),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
