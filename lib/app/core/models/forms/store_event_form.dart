import 'dart:io';

import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/extension/bool_extension.dart';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';
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
  final bool? isPublic;
  final bool? isAutoPostToClub;
  final List<String>? shareToClubs;

  final Map<String, dynamic>? errors;

  EventStoreFormModel({
    this.price,
    this.quota,
    this.isPublic,
    this.isAutoPostToClub,
    this.latitude,
    this.longitude,
    this.image,
    this.datetime,
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
    bool? isPublic,
    bool? isAutoPostToClub,
    List<String>? shareToClubs,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }

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
        isPublic,
        isAutoPostToClub,
        shareToClubs,
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
      'datetime': datetime != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime!)
          : null,
      'is_public': isPublic.toBool,
      'is_auto_post_to_club': isAutoPostToClub.toBool,
      'share_to_clubs': shareToClubs,
    };
  }

  @override
  bool isValidToUpdate(EventStoreFormModel formHasEdited) {
    throw UnimplementedError();
  }
}
