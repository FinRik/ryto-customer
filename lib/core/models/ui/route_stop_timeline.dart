import 'package:flutter/material.dart';

class RouteStopTimeline {
  final String title;
  final String subtitle;
  final Color indicatorColor;
  final bool isFilled;

  // Keep the raw components attached for contextual map deep-linking or modal usage
  final double latitude;
  final double longitude;
  final Widget? trailing;

  const RouteStopTimeline({
    required this.title,
    required this.subtitle,
    required this.indicatorColor,
    required this.latitude,
    required this.longitude,
    this.isFilled = true,
    this.trailing,
  });
}