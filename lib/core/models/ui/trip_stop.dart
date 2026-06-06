import 'package:flutter/material.dart';

import '../lat_lng.dart';

class TripStop {
  final LatLng location;
  final String city;
  final String time;
  final Color indicatorColor;
  final bool isLast;

  TripStop({
    required this.location,
    required this.city,
    required this.time,
    required this.indicatorColor,
    this.isLast = false,
  });
}