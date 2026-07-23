import 'package:flutter/material.dart';

import '../../../../../core/models/ui/trip_stop.dart';
import '../../../../widgets/location_fetch_builder.dart';

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
class TripStopTimelineItem extends StatelessWidget {
  final TripStop stop;
  final String duration;

  const TripStopTimelineItem({
    super.key,
    required this.stop,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Timeline Indicator
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: stop.indicatorColor.withOpacity(.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: stop.indicatorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              if (!stop.isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          /// Text Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(
                        stop.time,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(width: 6),

                      const Text("•"),

                      const SizedBox(width: 6),

                      Expanded(
                        child: LocationFetchBuilder(
                          coordinates: stop.location,
                          builder: (context,  address) {
                            return Text(
                              address?.address ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.city,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (!stop.isLast)
                      Column(
                        children: [
                          SizedBox(height: 12,),
                          TripDuration(duration: duration,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TripDuration extends StatelessWidget {
  final String duration;

  const TripDuration({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.access_time,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          duration,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}