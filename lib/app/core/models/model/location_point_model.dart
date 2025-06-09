class LocationPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationPoint({required this.latitude, required this.longitude, required this.timestamp});

  Map<String, dynamic> toJson() => { // Berguna jika ingin kirim ke backend nanti
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
  };

  @override
  String toString() {
    return 'Lat: ${latitude.toStringAsFixed(5)}, Lng: ${longitude.toStringAsFixed(5)} @ ${timestamp.toIso8601String()}';
  }
}