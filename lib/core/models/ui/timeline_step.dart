enum TimelineStepStatus {
  completed,
  current,
  upcoming,
}

class TimelineStep {
  final String title;
  final String? subtitle;
  final TimelineStepStatus status;

  TimelineStep({
    required this.title,
    this.subtitle,
    required this.status,
  });

  static final List<TimelineStep> tripSteps = [
    TimelineStep(
      title: 'Booked',
      status: TimelineStepStatus.completed,
    ),
    TimelineStep(
      title: 'Driver confirmed',
      status: TimelineStepStatus.completed,
    ),
    TimelineStep(
      title: 'Boarding',
      status: TimelineStepStatus.completed,
    ),
    TimelineStep(
      title: 'Departed',
      subtitle: 'In progress',
      status: TimelineStepStatus.current,
    ),
    TimelineStep(
      title: 'Near destination',
      status: TimelineStepStatus.upcoming,
    ),
    TimelineStep(
      title: 'Arrived',
      status: TimelineStepStatus.upcoming,
    ),
  ];
}