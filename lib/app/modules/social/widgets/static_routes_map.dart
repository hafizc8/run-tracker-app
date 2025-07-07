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
  late LatLngBounds _routeBounds;
  bool _isMapDataReady = false;

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
    if (!_isMapDataReady && widget.activityLogs.isNotEmpty) {
      _prepareMapData();
    }
  }

  void _prepareMapData() {
    final List<LatLng> routePoints = widget.activityLogs
        .map((log) => LatLng(log.latitude ?? 0, log.longitude ?? 0))
        .where((point) => point.latitude != 0 && point.longitude != 0)
        .toList();

    if (routePoints.isEmpty) {
      // Jika tidak ada titik valid, anggap data siap (untuk menampilkan pesan error)
      if (mounted) setState(() => _isMapDataReady = true);
      return;
    }

    final routePolyline = Polyline(
      polylineId: const PolylineId('activity_route'),
      color: darkColorScheme.primary,
      width: 4,
      points: routePoints,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    
    final startIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    final endIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

    final startMarker = Marker(
      markerId: const MarkerId('start_point'),
      position: routePoints.first,
      icon: startIcon,
      anchor: const Offset(0.5, 1.0),
    );

    final markers = {startMarker};
    if (routePoints.length > 1) {
      markers.add(Marker(
        markerId: const MarkerId('end_point'),
        position: routePoints.last,
        icon: endIcon,
        anchor: const Offset(0.5, 1.0),
      ));
    }

    _routeBounds = _boundsFromLatLngList(routePoints);

    // ✨ 2. Setelah semua data siap, panggil setState dan set flag menjadi true
    if (mounted) {
      setState(() {
        _polylines.add(routePolyline);
        _markers.addAll(markers);
        _isMapDataReady = true;
      });
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
      _mapController?.moveCamera(
        CameraUpdate.newLatLngBounds(_routeBounds, 60.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    
    return SizedBox(
      height: widget.height,
      child: ClipRRect( 
        borderRadius: BorderRadius.circular(16),
        // ✨ 3. Gunakan flag untuk menentukan apa yang akan ditampilkan
        child: _isMapDataReady
            ? _buildMap() // Jika data siap, tampilkan peta
            : _buildPlaceholder(), // Jika tidak, tampilkan placeholder
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget untuk membangun GoogleMap
  Widget _buildMap() {
    if (widget.activityLogs.isEmpty) {
      return Container(
        color: Colors.grey[800],
        child: const Center(child: Text("No route data available.")),
      );
    }

    return GoogleMap(
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      polylines: _polylines,
      markers: _markers,
      // ✨ KUNCI PERBAIKAN: Gunakan titik pertama rute sebagai posisi awal ✨
      // Ini menghilangkan "lompatan" dari (0,0)
      initialCameraPosition: CameraPosition(
        target: widget.activityLogs.first.latitude != null
            ? LatLng(widget.activityLogs.first.latitude!, widget.activityLogs.first.longitude!)
            : const LatLng(0, 0), // Fallback
        zoom: 15, // Zoom awal yang wajar
      ),
      onMapCreated: _onMapCreated,
      mapType: MapType.terrain,
    );
  }
}