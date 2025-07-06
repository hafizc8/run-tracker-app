import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/model/record_activity_model.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'dart:ui' as ui;

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
  final Set<Marker> _markers = {};

  late LatLngBounds _routeBounds = LatLngBounds(
    southwest: const LatLng(0, 0),
    northeast: const LatLng(0, 0),
  );

  bool _isMapInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cek dengan flag agar tidak berjalan berulang kali
    if (!_isMapInitialized && widget.activityLogs.isNotEmpty) {
      _setupMapData();
      _isMapInitialized = true;
    }
  }

  Future<BitmapDescriptor> _getMarkerIconFromAsset(String path, {int width = 100}) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedBytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  Future<void> _setupMapData() async {
    try {
      // 1. Muat ikon menggunakan fungsi helper yang baru
      final startIcon = await _getMarkerIconFromAsset('assets/icons/start_flag.png', width: 60);
      final endIcon = await _getMarkerIconFromAsset('assets/icons/stop_sign.png', width: 60);

      // 2. Siapkan semua elemen peta
      final List<LatLng> routePoints = widget.activityLogs
          .map((log) => LatLng(log.latitude ?? 0, log.longitude ?? 0))
          .where((point) => point.latitude != 0 && point.longitude != 0)
          .toList();

      if (routePoints.isEmpty || !mounted) return;

      final routePolyline = Polyline(
        polylineId: const PolylineId('activity_route'),
        color: darkColorScheme.primary,
        width: 3,
        points: routePoints,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );

      final startMarker = Marker(
        markerId: const MarkerId('start_point'),
        position: routePoints.first,
        icon: startIcon,
        anchor: const Offset(0.2, 1.0),
      );

      final markers = {startMarker};
      if (routePoints.length > 1) {
        markers.add(Marker(
          markerId: const MarkerId('end_point'),
          position: routePoints.last,
          icon: endIcon,
        ));
      }

      // 3. Panggil setState SATU KALI dengan semua data yang sudah siap
      setState(() {
        _polylines.add(routePolyline);
        _markers.addAll(markers);
        _routeBounds = _boundsFromLatLngList(routePoints);
      });

    } catch (e) {
      print('Error setting up map elements: $e');
    }
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
          CameraUpdate.newLatLngBounds(_routeBounds, 55.0),
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
          mapType: MapType.terrain,
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
          markers: _markers,
          
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