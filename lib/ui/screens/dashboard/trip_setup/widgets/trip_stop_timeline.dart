import 'package:flutter/material.dart';

import '../../../../../core/models/ui/trip_stop.dart';
import 'trip_stop_timeline_item.dart';

class TripStopTimeline extends StatelessWidget {
  final List<TripStop> stops;
  final String duration;

  const TripStopTimeline({
    super.key,
    required this.stops,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Stops
        ...List.generate(
          stops.length,
          (index) =>
              TripStopTimelineItem(stop: stops[index], duration: duration),
        ),
      ],
    );
  }
}
