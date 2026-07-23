import 'package:flutter/material.dart';

import '../../core/models/lat_lng.dart';
import '../../utils/helpers/location_utils.dart';
import 'loaders/circular_indicator.dart';

typedef LocationWidgetBuilder = Widget Function(BuildContext, LatLng?);

class LocationFetchBuilder extends StatefulWidget {
  final LatLng coordinates;
  final LocationWidgetBuilder builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const LocationFetchBuilder({
    super.key,
    required this.coordinates,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<LocationFetchBuilder> createState() => _LocationFetchBuilderState();
}

class _LocationFetchBuilderState extends State<LocationFetchBuilder> {
  late Future<LatLng?> _locationFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = LocationUtils.getAddressFromCoordinate(
      widget.coordinates,
    );
  }

  @override
  void didUpdateWidget(LocationFetchBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinates != widget.coordinates) {
      setState(() {
        _locationFuture = LocationUtils.getAddressFromCoordinate(
          widget.coordinates,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng?>(
      future: _locationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ??
              const Text(
                "Resolving address...",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              );
        }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return widget.loadingWidget ?? const Center(child: CircularIndicator());
//         }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          // Fallback gracefully to the coordinate string if reverse-geocoding fails
          return widget.errorWidget ??
              Text(
                "${widget.coordinates.lat.toStringAsFixed(4)}, ${widget.coordinates.lng.toStringAsFixed(4)}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              );
        }

        return widget.builder(context, snapshot.data!);
      },
    );
  }
}
