import 'dart:io';

import 'package:dio/dio.dart';

mixin FormModelMixin<T> {
  bool isValidToUpdate(T formHasEdited);
  Map<String, dynamic> toJson();

  /// Convert map menjadi FormData
  Future<FormData> toFormData() async {
    final map = toJson();
    final formMap = <String, dynamic>{};

    map.forEach((key, value) async {
      if (value != null) {
        if (value.runtimeType is File) {
          File file = value as File;
          formMap[key] = await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last);
        } else {
          formMap[key] = value;
        }
      }
    });

    return FormData.fromMap(formMap);
  }
}
