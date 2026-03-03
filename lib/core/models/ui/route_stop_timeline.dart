import 'package:flutter/material.dart';

class RouteStopTimeline {
  final String title;
  final String? subtitle;

  /// Color of the circle indicator
  final Color indicatorColor;

  /// Whether the circle is filled or hollow
  final bool isFilled;

  /// Optional trailing widget (e.g. "Short stop" badge)
  final Widget? trailing;

  const RouteStopTimeline({
    required this.title,
    this.subtitle,
    required this.indicatorColor,
    this.isFilled = true,
    this.trailing,
  });

  static final List<RouteStopTimeline> routeSteps = [
    RouteStopTimeline(
      title: 'Ojota Motor Park',
      subtitle: '08:00 AM',
      indicatorColor: Colors.blue,
    ),
    RouteStopTimeline(
      title: 'Sagamu Interchange',
      subtitle: '08:45 AM',
      indicatorColor: Colors.orange,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Short stop',
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange,
          ),
        ),
      ),
    ),
    RouteStopTimeline(
      title: 'Iwo Road, Ibadan',
      subtitle: '10:30 AM',
      indicatorColor: Colors.green,
    ),
  ];
}