import 'package:flutter/material.dart';

import '../../../../../core/models/ui/route_stop_timeline.dart';
import '../../../../widgets/customs/custom_card_widget.dart';

class RouteStopTimelineWidget extends StatelessWidget {
  final String headerTitle;
  final List<RouteStopTimeline> steps;

  /// Optional control for indicator size
  final double indicatorSize;

  /// Connector thickness
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
          // LEFT SIDE (Indicator + Line)
          Column(
            children: [
              _buildIndicator(),

              if (!isLast)
                Container(
                  width: lineThickness,
                  height: 50,
                  color: step.indicatorColor.withOpacity(0.3),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // RIGHT SIDE (Content)
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

                  if (step.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      step.subtitle!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],

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

  Widget _buildIndicator() {
    return Container(
      height: indicatorSize,
      width: indicatorSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: step.isFilled ? step.indicatorColor : Colors.transparent,
        border: Border.all(color: step.indicatorColor, width: 2),
      ),
    );
  }
}
