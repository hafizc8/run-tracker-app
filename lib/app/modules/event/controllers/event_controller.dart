import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/store_event_form.dart';
import 'package:zest_mobile/app/core/models/model/event_activity_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EventController extends GetxController {
  var dateController = TextEditingController();
  var addressController = TextEditingController();
  var imageController = TextEditingController();

  final _eventService = sl<EventService>();
  var eventActivities = <EventActivityModel>[].obs;
  var isLoading = false.obs;

  late ImagePicker _imagePicker;

  void requestPermission() async {
    await Geolocator.requestPermission();
  }

  var form = EventStoreFormModel().obs;

  @override
  onInit() {
    super.onInit();
    requestPermission();
    _imagePicker = ImagePicker();
    getActivites();
  }

  Future<void> setDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: form.value.datetime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      form.value = form.value.copyWith(
          datetime: picked, errors: form.value.errors, field: 'datetime');
      dateController.text = picked.toYyyyMmDdString();
    }
  }

  Future<void> imagePicker(BuildContext context) async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Get.back();
                XFile? image = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  form.value = form.value.copyWith(image: File(image.path));
                  imageController.text = image.path.split('/').last;
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.photo_library_outlined),
                  SizedBox(width: 8),
                  Text('Gallery'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                Get.back();
                XFile? image = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  form.value = form.value.copyWith(image: File(image.path));
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(width: 8),
                  Text('Camera'),
                ],
              ),
            ),
          ],
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  Future<void> getActivites() async {
    try {
      eventActivities.value = await _eventService.getEventActivity();
    } on AppException catch (e) {
      eventActivities.value = EventActivityModel.defaultListEventActivity();
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      eventActivities.value = EventActivityModel.defaultListEventActivity();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> storeEvent() async {
    isLoading.value = true;
    try {
      bool res = await _eventService.storeEvent(form.value);
      if (res) Get.offAllNamed(AppRoutes.social);
    } on AppException catch (e) {
      if (e.type == AppExceptionType.validation) {
        form.value = form.value.setErrors(e.errors!);
        return;
      }
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
