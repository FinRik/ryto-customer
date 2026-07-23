import 'package:flutter/material.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/models/ui/route_stop_timeline.dart';
import '../../../../../utils/route_timeline_mapper.dart';
import '../../../../widgets/customs/custom_card_widget.dart';

class DynamicRouteTimeline extends StatefulWidget {
  final RideSummary summary;

  const DynamicRouteTimeline({
    super.key,
    required this.summary,
  });

  @override
  State<DynamicRouteTimeline> createState() => _DynamicRouteTimelineState();
}

class _DynamicRouteTimelineState extends State<DynamicRouteTimeline> {
  // Store the future locally to cache its state between widget rebuilds
  late Future<List<RouteStopTimeline>> _timelineFuture;

  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  @override
  void didUpdateWidget(covariant DynamicRouteTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reactively refresh the geocoding layout if the data summary changes
    if (oldWidget.summary.booking?.id != widget.summary.booking?.id ||
        oldWidget.summary.passengers?.length != widget.summary.passengers?.length) {
      _loadTimeline();
    }
  }

  void _loadTimeline() {
    setState(() {
      _timelineFuture = RouteTimelineMapper.buildSecureTimelineSteps(widget.summary);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<List<RouteStopTimeline>>(
        future: _timelineFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          return RouteStopTimelineWidget(
            headerTitle: 'Route',
            steps: snapshot.data!,
          );
        },
      ),
    );
  }
}

class RouteStopTimelineWidget extends StatelessWidget {
  final String headerTitle;
  final List<RouteStopTimeline> steps;
  final double indicatorSize;
  final double lineThickness;

  const RouteStopTimelineWidget({
    super.key,
    required this.headerTitle,
    required this.steps,
    this.indicatorSize = 18,
    this.lineThickness = 2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      title: "Route",
      border: Border.all(style: BorderStyle.none),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            steps.length,
            (index) => RouteStopTimelineItem(
              step: steps[index],
              isLast: index == steps.length - 1,
              indicatorSize: indicatorSize,
              lineThickness: lineThickness,
            ),
          ),
        ],
      ),
    );
  }
}

class RouteStopTimelineItem extends StatelessWidget {
  final RouteStopTimeline step;
  final bool isLast;
  final double indicatorSize;
  final double lineThickness;

  const RouteStopTimelineItem({
    super.key,
    required this.step,
    required this.isLast,
    required this.indicatorSize,
    required this.lineThickness,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE (Indicator Circle + Line)
          Column(
            children: [
              Container(
                height: indicatorSize,
                width: indicatorSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.isFilled
                      ? step.indicatorColor
                      : Colors.transparent,
                  border: Border.all(color: step.indicatorColor, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: lineThickness,
                    color: step.indicatorColor.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // RIGHT SIDE (Content Information Block)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  // Displays user-friendly, clean address text smoothly by default
                  const SizedBox(height: 4),
                  Text(
                    step.subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 4),
                  if (step.trailing != null) ...[
                    const SizedBox(height: 6),
                    step.trailing!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
