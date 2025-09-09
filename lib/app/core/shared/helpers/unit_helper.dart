import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';

// Enum untuk mendefinisikan unit yang tersedia dengan aman.
enum DistanceUnit { km, mi }

class UnitHelper {
  // Ambil instance AuthService dari service locator.
  final AuthService _authService = sl<AuthService>();
  UserModel? get _user => _authService.user;

  /// Memformat jarak (dalam meter) ke string yang sesuai
  /// dengan preferensi unit pengguna (km atau mi).
  ///
  /// Akan default ke kilometer jika preferensi tidak diatur.
  String formatDistance(double distanceInMeters) {
    // 1. Dapatkan preferensi unit dari user yang sedang login.
    // Asumsi 'distance_unit' adalah key di userPreference, ganti jika perlu.
    final int? unitPreference = _user?.userPreference?.unit;
    
    DistanceUnit targetUnit = DistanceUnit.km; // Default ke km
    if (unitPreference == 1) {
      targetUnit = DistanceUnit.mi;
    }

    // 2. Lakukan konversi dan format berdasarkan unit yang sudah ditentukan.
    double convertedDistance;
    String unitSuffix;

    // Faktor konversi: 1 meter = 0.000621371 mil
    const double metersToMiles = 0.000621371;

    switch (targetUnit) {
      case DistanceUnit.km:
        convertedDistance = distanceInMeters / 1000;
        unitSuffix = 'km';
        break;
      case DistanceUnit.mi:
        convertedDistance = distanceInMeters * metersToMiles;
        unitSuffix = 'mi';
        break;
    }

    return "${convertedDistance.toStringAsFixed(2)} $unitSuffix";
  }

  /// ✨ FUNGSI BARU: Mendapatkan preferensi unit pengguna saat ini ✨
  DistanceUnit getUserUnit() {
    final int? unitPreference = _user?.userPreference?.unit;
    if (unitPreference == 1) {
      return DistanceUnit.mi;
    }
    return DistanceUnit.km; // Default ke km
  }
}
