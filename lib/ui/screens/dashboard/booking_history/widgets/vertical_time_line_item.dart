import 'package:flutter/material.dart';

import '../../../../../core/models/ui/timeline_step.dart';
import '../../../../widgets/customs/custom_card_widget.dart';

class VerticalTimeline extends StatelessWidget {
  final String? headerTitle;
  final List<TimelineStep> steps;

  const VerticalTimeline({super.key, this.headerTitle, required this.steps});

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      title: headerTitle ?? "Trip Status",
      border: Border.all(style: BorderStyle.none),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            steps.length,
            (index) => TimelineItem(
              step: steps[index],
              isLast: index == steps.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final TimelineStep step;
  final bool isLast;

  const TimelineItem({super.key, required this.step, required this.isLast});

  Color get primaryGreen => const Color(0xFF1F9D49);
  Color get primaryBlue => const Color(0xFF1E63E9);
  Color get inactiveGrey => const Color(0xFFD9D9D9);

  @override
  Widget build(BuildContext context) {
    final isCompleted = step.status == TimelineStepStatus.completed;
    final isCurrent = step.status == TimelineStepStatus.current;
    final isUpcoming = step.status == TimelineStepStatus.upcoming;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Indicator Column
          Column(
            children: [
              _buildIndicator(isCompleted, isCurrent, isUpcoming),

              if (!isLast)
                Container(
                  width: 2,
                  height: 28,
                  color: isCompleted
                      ? primaryGreen
                      : inactiveGrey.withOpacity(0.4),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Right Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isUpcoming ? Colors.grey : Colors.black,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    Text(
                      step.subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryBlue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isCompleted, bool isCurrent, bool isUpcoming) {
    if (isCompleted) {
      return Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(shape: BoxShape.circle, color: primaryGreen),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    }

    if (isCurrent) {
      return Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(shape: BoxShape.circle, color: primaryBlue),
        child: Center(
          child: Container(
            height: 12,
            width: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: inactiveGrey.withOpacity(0.3),
      ),
      child: Center(
        child: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 2),
          ),
        ),
      ),
    );
  }
}