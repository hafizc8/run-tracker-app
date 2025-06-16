import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/extension/bool_extension.dart';
import 'package:zest_mobile/app/core/extension/time_extension.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/store_event_form.dart';
import 'package:zest_mobile/app/core/models/model/club_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/event_activity_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/views/add_clubs_view.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EventActionController extends GetxController {
  var dateController = TextEditingController();
  var addressController = TextEditingController();
  var placeNameController = TextEditingController();
  var imageController = TextEditingController();

  final _eventService = sl<EventService>();
  var eventActivities = <EventActivityModel>[].obs;
  var eventClubs = <ClubMiniModel>[].obs;
  Rx<EventModel?> event = Rx(null);

  final eventController = Get.find<EventController>();

  /// Ini untuk digunakan di dalam dialog (sementara)
  var tempSelectedIds = <ClubMiniModel>[].obs;

  var isLoading = false.obs;
  var isEdit = false.obs;
  var isLoadingClub = false.obs;

  late ImagePicker _imagePicker;

  void requestPermission() async {
    await Geolocator.requestPermission();
  }

  var form = EventStoreFormModel().obs;
  var original = EventStoreFormModel().obs;

  bool get isValidToUpdate => original.value.isValidToUpdate(form.value);

  var from = 'list'.obs;
  @override
  onInit() {
    super.onInit();
    requestPermission();
    _imagePicker = ImagePicker();
    getActivites();
    getClubs();
  }

  void resetForm() {
    form.value = EventStoreFormModel();
    original.value = EventStoreFormModel();
    dateController.text = '';
    addressController.text = '';
    placeNameController.text = '';
    imageController.text = '';
    isEdit.value = false;
    event.value = null;
  }

  Future<void> setDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: form.value.datetime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? startTime;
      TimeOfDay? endTime;

      bool? resp = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          startTime = form.value.startTime?.toTimeOfDay();
          endTime = form.value.endTime?.toTimeOfDay();
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                surfaceTintColor: Colors.white,
                title: const Text('Choose Time'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Waktu Mulai
                    ListTile(
                      title: const Text('Start Time'),
                      subtitle: Row(
                        children: [
                          if (startTime != null) ...[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  startTime = null;
                                  endTime = null;
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            startTime != null
                                ? '${startTime!.hour.toString().padLeft(2, '0')}.${startTime!.minute.toString().padLeft(2, '0')}'
                                : 'No time selected',
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() => startTime = picked);
                        }
                      },
                    ),
                    // Waktu Berakhir
                    ListTile(
                      title: const Text('End Time'),
                      subtitle: Row(
                        children: [
                          if (endTime != null) ...[
                            IconButton(
                              onPressed: () {
                                setState(() => endTime = null);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            endTime != null
                                ? '${endTime!.hour.toString().padLeft(2, '0')}.${endTime!.minute.toString().padLeft(2, '0')}'
                                : 'No time selected',
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: endTime ?? TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() => endTime = picked);
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: startTime == null
                        ? null
                        : () {
                            if (startTime != null) {
                              Get.back(result: true);
                            }
                          },
                    child: const Text('Simpan'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (resp != null && !resp) {
        return;
      }
      if (startTime != null) {
        String formattedDate = DateFormat('d MMM yyyy').format(pickedDate);
        String result;
        if (startTime != null && endTime != null) {
          result =
              '$formattedDate, ${formatTime(startTime!)}–${formatTime(endTime!)}';
        } else {
          result = '$formattedDate, ${formatTime(startTime!)}-Finish';
        }

        dateController.text = result;
        form.value = form.value.copyWith(
          datetime: pickedDate,
          startTime: formatTimeOfDayToHms(startTime!),
          endTime: endTime == null ? 'null' : formatTimeOfDayToHms(endTime!),
          errors: form.value.errors,
          field: 'date',
        );
      } else {
        dateController.text = '';
        form.value = form.value.copyWith(
          datetime: null,
          startTime: 'null',
          endTime: 'null',
          errors: form.value.errors,
          field: 'date',
        );
      }
    }
  }

  String formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';

  String formatTimeOfDayToHms(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  Future<void> imagePicker(BuildContext context) async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Theme.of(context).colorScheme.background,
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
              child: Row(
                children: [
                  const Icon(Icons.photo_library_outlined),
                  const SizedBox(width: 8),
                  Text(
                    'Gallery',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
              child: Row(
                children: [
                  const Icon(Icons.camera_alt_outlined),
                  const SizedBox(width: 8),
                  Text(
                    'Camera',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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

  Future<void> getClubs() async {
    isLoadingClub.value = true;
    try {
      eventClubs.value = await _eventService.getEventClubs();
    } on AppException catch (e) {
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
      isLoadingClub.value = false;
    }
  }

  Future<void> storeEvent() async {
    isLoading.value = true;
    try {
      final EventModel? res = await _eventService.storeEvent(form.value);
      if (res != null) {
        Get.back(result: res);
      }
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

  Future<void> updateEvent() async {
    isLoading.value = true;
    try {
      final EventModel? res =
          await _eventService.updateEvent(form.value, event.value?.id ?? '');
      if (res != null) {
        if (from.value == 'list') {
          Get.offNamed(AppRoutes.socialYourPageEventDetail,
              arguments: {'eventId': res.id});
        } else if (from.value == 'detail') {
          Get.back(result: res);
        }

        int index = eventController.events
            .indexWhere((element) => element.id == res.id);

        if (index != -1) {
          eventController.events[index] = res;
        }
      }
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

  void toggleClub(ClubMiniModel club) {
    if (tempSelectedIds.contains(club)) {
      tempSelectedIds.remove(club);
    } else {
      tempSelectedIds.add(club);
    }
  }

  void unselectAll() {
    tempSelectedIds.clear();
  }

  void selectAll() {
    tempSelectedIds.clear();
    tempSelectedIds.addAll(eventClubs);
  }

  /// commit pilihan ketika tekan CHOOSE
  void commitSelection() {
    Get.back();
    form.value = form.value.copyWith(shareToClubs: tempSelectedIds.toList());
  }

  void showAddClubsDialog() {
    tempSelectedIds.clear();
    tempSelectedIds.value = List.from(form.value.shareToClubs?.toList() ?? []);
    Get.bottomSheet(
      backgroundColor: const Color(0xFF4C4C4C),
      const FractionallySizedBox(
        heightFactor: 0.5,
        child: AddClubs(),
      ),
      isScrollControlled: true,
    );
  }

  void createEventFromClub(ClubMiniModel club) {
    form.value = form.value.copyWith(
      isAutoPostToClub: true,
      shareToClubs: [club],
    );
  }

  Future<File?> getCachedImageFile(String imageUrl) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
    return fileInfo?.file;
  }

  void gotToEdit(EventModel event, {String from = 'list'}) {
    this.from
      ..value = from
      ..refresh();
    this.event.value = event;
    isEdit.value = true;
    String formattedDate = DateFormat('d MMM yyyy').format(event.datetime!);

    String result =
        '$formattedDate, ${formatTime(event.startTime!)}–${formatTime(event.endTime!)}';
    form.value = EventStoreFormModel(
      title: event.title,
      description: event.description,
      price: event.price,
      latitude: double.parse(event.latitude!),
      longitude: double.parse(event.longitude!),
      quota: event.quota,
      datetime: event.datetime,
      startTime: formatTimeOfDayToHms(event.startTime ?? TimeOfDay.now()),
      endTime: formatTimeOfDayToHms(event.endTime ?? TimeOfDay.now()),
      isPublic: bool.parse(event.isPublic.toBool),
      activity: EventActivityModel(
        value: event.activity,
        label: event.activity,
        image: '',
      ),
    );
    original.value = form.value;
    imageController.text =
        event.imageUrl == null ? '' : event.imageUrl.split('/').last;
    addressController.text = event.address;
    dateController.text = result;

    getCachedImageFile(event.imageUrl ?? '').then((value) {
      form.value = form.value.copyWith(image: value);
      original.value = form.value;
    }).onError((error, stackTrace) {
      form.value = form.value.copyWith(image: null);
      original.value = form.value;
    });

    Get.toNamed(AppRoutes.eventCreate);
  }
}
