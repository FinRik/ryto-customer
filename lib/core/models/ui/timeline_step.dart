// enum TripProgressStep {
//   booked,          // Map from: PENDING, SCHEDULED, BOOKED
//   driverConfirmed, // Map from: DRIVER_ACCEPTED
//   boarding,        // Map from: (Optional/Intermediate step depending on business logic, or grouped)
//   inProgress,      // Map from: TRIP_STARTED
//   arrived,         // Map from: TRIP_COMPLETED
// }
//
// enum TimelineStepStatus {
//   completed,
//   current,
//   upcoming,
// }
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
//   static List<TimelineStep> generateTimeline(String? backendStatus) {
//     final status = backendStatus?.toUpperCase() ?? "PENDING";
//
//     // 1. Determine the active index in our 5-step UI visualization
//     int activeIndex = 0;
//     String? currentSubtitle;
//     bool isRejected = status == "DRIVER_REJECTED";
//
//     if (status == "PENDING" || status == "SCHEDULED" || status == "BOOKED") {
//       activeIndex = 0; // Booked step is active
//     } else if (status == "DRIVER_ACCEPTED") {
//       activeIndex = 1; // Driver confirmed step is active
//     } else if (status == "TRIP_STARTED") {
//       activeIndex = 3; // Departed / In Progress step is active
//       currentSubtitle = "In progress";
//     } else if (status == "TRIP_COMPLETED") {
//       activeIndex = 5; // Arrived step is active (marks everything completed)
//     }
//
//     // Helper to assign statuses based on current index position
//     TimelineStepStatus getStatusForIndex(int index) {
//       if (isRejected) return TimelineStepStatus.upcoming;
//       if (index < activeIndex) return TimelineStepStatus.completed;
//       if (index == activeIndex) return TimelineStepStatus.current;
//       return TimelineStepStatus.upcoming;
//     }
//
//     // 2. Map structural array linearly
//     return [
//       TimelineStep(
//         title: 'Booked',
//         status: getStatusForIndex(0),
//       ),
//       TimelineStep(
//         title: 'Driver confirmed',
//         status: isRejected ? TimelineStepStatus.upcoming : getStatusForIndex(1),
//         subtitle: isRejected ? 'Driver declined this trip' : null,
//       ),
//       TimelineStep(
//         title: 'Boarding',
//         status: getStatusForIndex(2),
//       ),
//       TimelineStep(
//         title: 'Departed',
//         subtitle: activeIndex == 3 ? currentSubtitle : null,
//         status: getStatusForIndex(3),
//       ),
//       TimelineStep(
//         title: 'Near destination',
//         status: getStatusForIndex(4),
//       ),
//       TimelineStep(
//         title: 'Arrived',
//         status: getStatusForIndex(5),
//       ),
//     ];
//   }
// }
// //
// // class TimelineStep {
// //   final String title;
// //   final String? subtitle;
// //   final TimelineStepStatus status;
// //
// //   TimelineStep({
// //     required this.title,
// //     this.subtitle,
// //     required this.status,
// //   });
// //
// //   static final List<TimelineStep> tripSteps = [
// //     TimelineStep(
// //       title: 'Booked',
// //       status: TimelineStepStatus.completed,
// //     ),
// //     TimelineStep(
// //       title: 'Driver confirmed',
// //       status: TimelineStepStatus.completed,
// //     ),
// //     TimelineStep(
// //       title: 'Boarding',
// //       status: TimelineStepStatus.completed,
// //     ),
// //     TimelineStep(
// //       title: 'Departed',
// //       subtitle: 'In progress',
// //       status: TimelineStepStatus.current,
// //     ),
// //     TimelineStep(
// //       title: 'Near destination',
// //       status: TimelineStepStatus.upcoming,
// //     ),
// //     TimelineStep(
// //       title: 'Arrived',
// //       status: TimelineStepStatus.upcoming,
// //     ),
// //   ];
// // }


enum TimelineStepStatus { completed, current, upcoming }

class TimelineStep {
  final String title;
  final String? subtitle;
  final TimelineStepStatus status;

  TimelineStep({
    required this.title,
    this.subtitle,
    required this.status,
  });

  /// The master mapper combining parent and booking states into linear steps
  static List<TimelineStep> generateTimeline({
    required String parentStatus,
    required String? bookingStatus,
  }) {
    // 1. Identify active flags
    final isParentCanceled = parentStatus == "CANCELED";
    final isBookingCanceled = bookingStatus == "CUSTOMER_CANCELED" || bookingStatus == "CANCELED";
    final isCanceled = isParentCanceled || isBookingCanceled;

    final isRejected = bookingStatus == "DRIVER_REJECTED";
    final isAccepted = bookingStatus == "DRIVER_ACCEPTED";
    final isStarted = parentStatus == "TRIP_STARTED" || bookingStatus == "TRIP_STARTED";
    final isCompleted = parentStatus == "TRIP_COMPLETED" || bookingStatus == "TRIP_COMPLETED";

    // 2. Map structural execution indices (0 to 4)
    int currentStepIndex = 0;
    if (isCompleted) {
      currentStepIndex = 4;
    } else if (isStarted) {
      currentStepIndex = 3;
    } else if (isAccepted) {
      currentStepIndex = 2;
    } else if (parentStatus == "BOOKED" || bookingStatus == "BOOKED") {
      currentStepIndex = 1;
    }

    // 3. Define raw template steps
    final stepsTemplate = [
      _StepTemplate("Trip Requested", "Your match booking is logged"),
      _StepTemplate("Waiting for Match", "Finding the nearest available route"),
      _StepTemplate("Driver Confirmed", "Driver is heading to your pickup zone"),
      _StepTemplate("Trip in Progress", "En route to destination city"),
      _StepTemplate("Arrived Safely", "Journey completed successfully"),
    ];

    // 4. Handle Terminal Failure Overrides (Canceled / Declined exceptions)
    if (isCanceled) {
      return [
        TimelineStep(
          title: "Trip Voided",
          subtitle: isBookingCanceled ? "Canceled by passenger" : "Canceled by dispatch provider",
          status: TimelineStepStatus.current,
        ),
      ];
    }

    if (isRejected) {
      return [
        TimelineStep(
          title: "Match Declined",
          subtitle: "Driver declined allocation. Relisting ride request...",
          status: TimelineStepStatus.current,
        ),
      ];
    }

    // 5. Generate normal timeline matrices dynamically
    return List.generate(stepsTemplate.length, (index) {
      final template = stepsTemplate[index];
      TimelineStepStatus computedStatus;

      if (index < currentStepIndex) {
        computedStatus = TimelineStepStatus.completed;
      } else if (index == currentStepIndex) {
        computedStatus = TimelineStepStatus.current;
      } else {
        computedStatus = TimelineStepStatus.upcoming;
      }

      return TimelineStep(
        title: template.title,
        subtitle: computedStatus == TimelineStepStatus.current ? template.subtitle : null,
        status: computedStatus,
      );
    });
  }
}

class _StepTemplate {
  final String title;
  final String subtitle;
  _StepTemplate(this.title, this.subtitle);
}