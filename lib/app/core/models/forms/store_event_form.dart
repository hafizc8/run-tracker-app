import 'dart:io';

import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/extension/bool_extension.dart';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';
import 'package:zest_mobile/app/core/models/model/club_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/event_activity_model.dart';

class EventStoreFormModel extends FormModel<EventStoreFormModel>
    with FormModelMixin<EventStoreFormModel> {
  final EventActivityModel? activity;
  final String? title;
  final String? description;
  final int? price;
  final double? latitude;
  final double? longitude;
  final int? quota;
  final File? image;
  final DateTime? datetime;
  final String? startTime;
  final String? endTime;
  final bool? isPublic;
  final bool? isAutoPostToClub;
  final List<ClubMiniModel>? shareToClubs;

  final Map<String, dynamic>? errors;

  EventStoreFormModel({
    this.price,
    this.quota,
    this.isPublic = true,
    this.isAutoPostToClub,
    this.latitude,
    this.longitude,
    this.image,
    this.datetime,
    this.startTime,
    this.endTime,
    this.shareToClubs,
    this.activity,
    this.title,
    this.description,
    this.errors,
  });

  @override
  EventStoreFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  EventStoreFormModel copyWith({
    EventActivityModel? activity,
    String? title,
    String? description,
    int? price,
    double? latitude,
    double? longitude,
    int? quota,
    File? image,
    DateTime? datetime,
    String? startTime,
    String? endTime,
    bool? isPublic,
    bool? isAutoPostToClub,
    List<ClubMiniModel>? shareToClubs,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }

    print('startTime: $startTime');

    return EventStoreFormModel(
      activity: activity ?? this.activity,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      quota: quota ?? this.quota,
      image: image ?? this.image,
      datetime: datetime ?? this.datetime,
      startTime: startTime,
      endTime: endTime,
      isPublic: isPublic ?? this.isPublic,
      isAutoPostToClub: isAutoPostToClub ?? this.isAutoPostToClub,
      shareToClubs: shareToClubs ?? this.shareToClubs,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
        activity,
        title,
        description,
        price,
        latitude,
        longitude,
        quota,
        image,
        datetime,
        startTime,
        endTime,
        isPublic,
        isAutoPostToClub,
        shareToClubs,
        errors
      ];

  @override
  EventStoreFormModel setErrors(Map<String, List> errorsMap) {
    Map<String, dynamic> newErrors = {
      for (final entry in errorsMap.entries) entry.key: entry.value.first
    };

    return copyWith(
      errors: newErrors,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'activity': activity?.value,
      'title': title,
      'description': description,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'quota': quota,
      'image': image,
      'date':
          datetime != null ? DateFormat('yyyy-MM-dd').format(datetime!) : null,
      'start_time': startTime,
      'end_time': endTime,
      'is_public': isPublic.toBool,
      'is_auto_post_to_club': isAutoPostToClub.toBool,
      'share_to_clubs': shareToClubs?.map((obj) => obj.id).toList(),
    };
  }

  @override
  bool isValidToUpdate(EventStoreFormModel formHasEdited) {
    return activity != formHasEdited.activity ||
        title != formHasEdited.title ||
        description != formHasEdited.description ||
        latitude != formHasEdited.latitude ||
        longitude != formHasEdited.longitude ||
        quota != formHasEdited.quota ||
        image != formHasEdited.image ||
        datetime != formHasEdited.datetime ||
        isPublic != formHasEdited.isPublic ||
        startTime != formHasEdited.startTime ||
        endTime != formHasEdited.endTime ||
        price != formHasEdited.price;
  }
}
