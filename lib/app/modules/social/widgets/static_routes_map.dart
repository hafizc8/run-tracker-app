import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/model/record_activity_model.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class StaticRouteMap extends StatefulWidget {
  final List<RecordActivityLogModel> activityLogs;
  final double height;

  const StaticRouteMap({
    super.key,
    required this.activityLogs,
    this.height = 310,
  });

  @override
  State<StaticRouteMap> createState() => _StaticRouteMapState();
}

class _StaticRouteMapState extends State<StaticRouteMap> with AutomaticKeepAliveClientMixin<StaticRouteMap> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  late LatLngBounds _routeBounds;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Hanya proses jika data log tidak kosong
    if (widget.activityLogs.isNotEmpty) {
      _preparePolylineAndBounds();
    }
  }

  /// Mempersiapkan data Polyline dan menghitung bounds untuk kamera
  void _preparePolylineAndBounds() {
    // 1. Konversi data log Anda menjadi List<LatLng>
    final List<LatLng> routePoints = widget.activityLogs
        .map((log) => LatLng(log.latitude ?? 0, log.longitude ?? 0))
        .toList();

    if (routePoints.isEmpty) return;

    // 2. Buat objek Polyline
    final Polyline routePolyline = Polyline(
      polylineId: const PolylineId('activity_route'),
      color: darkColorScheme.primary, // Ganti warna sesuai tema
      width: 5,
      points: routePoints,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    // 3. Hitung bounds dari semua titik untuk memposisikan kamera
    _routeBounds = _boundsFromLatLngList(routePoints);

    // 4. Update state dengan polyline yang baru dibuat
    setState(() {
      _polylines.add(routePolyline);
    });
  }

  /// Fungsi helper untuk mendapatkan LatLngBounds dari daftar titik
  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? minLat, maxLat, minLng, maxLng;

    for (final latLng in list) {
      if (minLat == null) {
        // Inisialisasi pada titik pertama
        minLat = maxLat = latLng.latitude;
        minLng = maxLng = latLng.longitude;
      } else {
        // Perbarui nilai min/max
        if (latLng.latitude < minLat) minLat = latLng.latitude;
        if (latLng.latitude > maxLat!) maxLat = latLng.latitude;
        if (latLng.longitude < minLng!) minLng = latLng.longitude;
        if (latLng.longitude > maxLng!) maxLng = latLng.longitude;
      }
    }
    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Pindahkan kamera ke area polyline setelah peta siap
    if (widget.activityLogs.isNotEmpty) {
      // Beri sedikit jeda agar perpindahan kamera lebih mulus
      Future.delayed(const Duration(milliseconds: 100), () {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(_routeBounds, 50.0), // 50.0 adalah padding
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    
    // Jika tidak ada data log, tampilkan pesan atau peta kosong
    if (widget.activityLogs.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text("No route data available.")),
      );
    }

    return SizedBox(
      height: widget.height,
      // Gunakan ClipRRect agar peta memiliki sudut melengkung sesuai Container
      child: ClipRRect( 
        borderRadius: BorderRadius.circular(0),
        child: GoogleMap(
          // --- 2. Membuat Peta Statis (Tidak Interaktif) ---
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          
          // --- 1. Menampilkan Polyline ---
          polylines: _polylines,
          
          // --- 3. Memposisikan Kamera ---
          initialCameraPosition: const CameraPosition(
            // Posisi awal bisa di mana saja, karena akan diperbarui di onMapCreated
            target: LatLng(0, 0),
            zoom: 1,
          ),
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }
}