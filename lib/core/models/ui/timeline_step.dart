enum TripProgressStep {
  booked,          // Map from: PENDING, SCHEDULED, BOOKED
  driverConfirmed, // Map from: DRIVER_ACCEPTED
  boarding,        // Map from: (Optional/Intermediate step depending on business logic, or grouped)
  inProgress,      // Map from: TRIP_STARTED
  arrived,         // Map from: TRIP_COMPLETED
}

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

  /// Factory method to generate the timeline dynamically based on the backend status string
  static List<TimelineStep> generateTimeline(String? backendStatus) {
    final status = backendStatus?.toUpperCase() ?? "PENDING";

    // 1. Determine the active index in our 5-step UI visualization
    int activeIndex = 0;
    String? currentSubtitle;
    bool isRejected = status == "DRIVER_REJECTED";

    if (status == "PENDING" || status == "SCHEDULED" || status == "BOOKED") {
      activeIndex = 0; // Booked step is active
    } else if (status == "DRIVER_ACCEPTED") {
      activeIndex = 1; // Driver confirmed step is active
    } else if (status == "TRIP_STARTED") {
      activeIndex = 3; // Departed / In Progress step is active
      currentSubtitle = "In progress";
    } else if (status == "TRIP_COMPLETED") {
      activeIndex = 5; // Arrived step is active (marks everything completed)
    }

    // Helper to assign statuses based on current index position
    TimelineStepStatus getStatusForIndex(int index) {
      if (isRejected) return TimelineStepStatus.upcoming; // Or handle custom error UI
      if (index < activeIndex) return TimelineStepStatus.completed;
      if (index == activeIndex) return TimelineStepStatus.current;
      return TimelineStepStatus.upcoming;
    }

    // 2. Map structural array linearly
    return [
      TimelineStep(
        title: 'Booked',
        status: getStatusForIndex(0),
      ),
      TimelineStep(
        title: 'Driver confirmed',
        status: isRejected ? TimelineStepStatus.upcoming : getStatusForIndex(1),
        subtitle: isRejected ? 'Driver declined this trip' : null,
      ),
      TimelineStep(
        title: 'Boarding',
        status: getStatusForIndex(2),
      ),
      TimelineStep(
        title: 'Departed',
        subtitle: activeIndex == 3 ? currentSubtitle : null,
        status: getStatusForIndex(3),
      ),
      TimelineStep(
        title: 'Near destination',
        status: getStatusForIndex(4),
      ),
      TimelineStep(
        title: 'Arrived',
        status: getStatusForIndex(5),
      ),
    ];
  }
}
//
// class TimelineStep {
//   final String title;
//   final String? subtitle;
//   final TimelineStepStatus status;
//
//   TimelineStep({
//     required this.title,
//     this.subtitle,
//     required this.status,
//   });
//
//   static final List<TimelineStep> tripSteps = [
//     TimelineStep(
//       title: 'Booked',
//       status: TimelineStepStatus.completed,
//     ),
//     TimelineStep(
//       title: 'Driver confirmed',
//       status: TimelineStepStatus.completed,
//     ),
//     TimelineStep(
//       title: 'Boarding',
//       status: TimelineStepStatus.completed,
//     ),
//     TimelineStep(
//       title: 'Departed',
//       subtitle: 'In progress',
//       status: TimelineStepStatus.current,
//     ),
//     TimelineStep(
//       title: 'Near destination',
//       status: TimelineStepStatus.upcoming,
//     ),
//     TimelineStep(
//       title: 'Arrived',
//       status: TimelineStepStatus.upcoming,
//     ),
//   ];
// }