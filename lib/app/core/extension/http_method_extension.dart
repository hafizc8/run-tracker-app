import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';

extension HttpMethodExtension on HttpMethod {
  String get methodString {
    switch (this) {
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.get:
      default:
        return 'GET';
    }
  }
}
