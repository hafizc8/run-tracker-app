import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/model/location_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class LocationService {
  final ApiService _apiService;
  LocationService(this._apiService);

  Future<LatLng> getCurrentLocation() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocationModel>?> searchPlace(String query) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.searchLocation(query),
        method: HttpMethod.get,
      );
      final predictions = response.data['predictions'];
      if (response.statusCode != 200) {
        throw Exception('Failed to load search results');
      }

      return List.from(predictions).map<LocationModel>((prediction) {
        return LocationModel.fromJson(prediction);
      }).toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.addressFromLatLang(latLng),
        method: HttpMethod.get,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get address');
      }

      if (List.from(response.data['results']).isNotEmpty) {
        return response.data['results'][0]['formatted_address'];
      }
      return 'Alamat tidak ditemukan';
    } catch (_) {
      rethrow;
    }
  }

  Future<String> getCityFromLatLng(LatLng latLng) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.addressFromLatLang(latLng),
        method: HttpMethod.get,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get address');
      }

      final results = List.from(response.data['results']);
      if (results.isEmpty) {
        return 'Kota tidak ditemukan';
      }

      final addressComponents = results.first['address_components'] as List<dynamic>;
      for (var component in addressComponents) {
        final types = component['types'] as List<dynamic>;
        if (types.contains('administrative_area_level_2')) {
          return component['long_name'].toString();
        }
      }

      return 'Kota tidak ditemukan';
    } catch (e) {
      rethrow;
    }
  }

  Future<LatLng> selectPlace(String placeId) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.selectPlace(placeId),
        method: HttpMethod.get,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load place details');
      }

      final location = response.data['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } catch (_) {
      rethrow;
    }
  }
}
