import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/helpers/location_utils.dart';

class TripRouteMap extends StatefulWidget {
  final double? olat, olng, dlat, dlng;
  final Set<Polyline> polylines;

  const TripRouteMap({
    super.key,
    required this.olat,
    required this.olng,
    required this.dlat,
    required this.dlng,
    this.polylines = const {},
  });

  @override
  State<TripRouteMap> createState() => _TripRouteMapState();
}

class _TripRouteMapState extends State<TripRouteMap> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng _currentLocation = const LatLng(0, 0);
  bool _isLocationLoaded = false;

  bool get _hasOrigin => widget.olat != null && widget.olng != null;
  bool get _hasDestination => widget.dlat != null && widget.dlng != null;
  bool get _hasBothPoints => _hasOrigin && _hasDestination;

  @override
  void initState() {
    super.initState();
    _fetchCurrentCoordinates();
  }

  @override
  void didUpdateWidget(covariant TripRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.olat != widget.olat || oldWidget.dlat != widget.dlat) &&
        _controller.isCompleted) {
      _fitToScreen();
    }
  }

  Future<void> _fetchCurrentCoordinates() async {
    try {
      final latLng = await LocationUtils.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(latLng.lat, latLng.lng);
          _isLocationLoaded = true;
        });
      }
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  Set<Marker> _getMarkers() {
    final Set<Marker> markers = {};

    if (_hasOrigin) {
      markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(widget.olat!, widget.olng!),
          infoWindow: const InfoWindow(title: 'Pickup Point'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    if (_hasDestination) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(widget.dlat!, widget.dlng!),
          infoWindow: const InfoWindow(title: 'Drop-off Point'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    return markers;
  }

  Future<void> _fitToScreen() async {
    if (!_hasBothPoints) return; // Cannot fit screen if points are missing

    final GoogleMapController controller = await _controller.future;

    // Safely unwrap variables using local non-nullable shadows
    final double oLat = widget.olat!;
    final double oLng = widget.olng!;
    final double dLat = widget.dlat!;
    final double dLng = widget.dlng!;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(oLat < dLat ? oLat : dLat, oLng < dLng ? oLng : dLng),
      northeast: LatLng(oLat > dLat ? oLat : dLat, oLng > dLng ? oLng : dLng),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  @override
  Widget build(BuildContext context) {
    // Determine the initial camera focus point.
    // Prioritizes origin if available, otherwise falls back to current user location.
    final LatLng initialTarget = _hasOrigin
        ? LatLng(widget.olat!, widget.olng!)
        : _currentLocation;

    return GoogleMap(
      // Key helps Flutter rebuild map properly if initial target defaults switch
      key: ValueKey('${initialTarget.latitude}_${initialTarget.longitude}'),
      initialCameraPosition: CameraPosition(target: initialTarget, zoom: 12),
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _getMarkers(),
      polylines: widget.polylines,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _fitToScreen();
      },
    );
  }
}
