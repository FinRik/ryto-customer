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
      _StepTemplate("Driver Matched", "Finding the nearest available route"),
      _StepTemplate("Driver Confirmed", "Driver is heading to your pickup zone"),
      _StepTemplate("Trip in Progress", "En route to Destination"),
      _StepTemplate("Trip Completed", "Journey completed successfully"),
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