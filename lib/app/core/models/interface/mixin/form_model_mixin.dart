import 'dart:io';

import 'package:dio/dio.dart';

mixin FormModelMixin<T> {
  bool isValidToUpdate(T formHasEdited);
  Map<String, dynamic> toJson();

  /// Convert map menjadi FormData
  Future<FormData> toFormData() async {
    final map = toJson();

    final formMap = <String, dynamic>{};
    final files = <MapEntry<String, MultipartFile>>[];
    final datas = <MapEntry<String, String>>[];

    for (var entry in map.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value != null) {
        if (value is File) {
          formMap[key] = await MultipartFile.fromFile(value.path,
              filename: value.path.split('/').last);
        } else if (value is List<File>) {
          for (var file in value) {
            files.add(
              MapEntry(
                '$key[]',
                await MultipartFile.fromFile(file.path,
                    filename: file.path.split('/').last),
              ),
            );
          }
        } else if (value is List) {
          for (var data in value) {
            datas.add(MapEntry('$key[]', data));
          }
        } else {
          formMap[key] = value;
        }
      }
    }

    return FormData.fromMap(formMap)
      ..fields.addAll(datas)
      ..files.addAll(files);
  }
}
