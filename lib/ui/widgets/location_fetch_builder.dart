import 'package:flutter/material.dart';

import '../../core/models/lat_lng.dart';
import '../../utils/helpers/location_utils.dart';
import 'loaders/circular_indicator.dart';

typedef LocationWidgetBuilder = Widget Function(BuildContext, LatLng?);

class LocationFetchBuilder extends StatefulWidget {
  final LatLng address;
  final LocationWidgetBuilder builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const LocationFetchBuilder({
    super.key,
    required this.address,
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
    _locationFuture = LocationUtils.getAddressFromCoordinate(widget.address);
  }

  // @override
  // void didUpdateWidget(LocationFetchBuilder oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Refresh the future if the address changes
  //   if (oldWidget.address != widget.address) {
  //     _locationFuture = LocationUtils.getAddressFromCoordinate(widget.address);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng?>(
      future: _locationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? const Center(child: CircularIndicator());
        }

        if (snapshot.hasError) {
          return widget.errorWidget ?? const Center(child: Text('Error loading location'));
        }

        // Pass the result (which could be null) to your custom builder
        return widget.builder(context, snapshot.data);
      },
    );
  }
}