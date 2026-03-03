/// Data model for each stop/point on the route
class RouteStep {
  final String time;
  final String place;       // e.g. "Ojota Motor Park", "Iwo Road"
  final String city;
  final String? duration;   // e.g. "2h 30m" — shown only for completed segments
  final bool isPast;        // already completed / departed
  final bool isActive;      // current position / ongoing

  const RouteStep({
    required this.time,
    required this.place,
    required this.city,
    this.duration,
    this.isPast = false,
    this.isActive = false,
  });

  static final List<RouteStep> routeSteps = [
    RouteStep(
      time: "08:00 AM",
      place: "Ojota Motor Park",
      city: "Lagos",
      isPast: true,
      duration: "2h 30m",
    ),
    RouteStep(
      time: "10:30 AM",
      place: "Iwo Road",
      city: "Ibadan",
      isActive: true,
    ),
    // RouteStep(
    //   time: "01:45 PM",
    //   place: "Challenge Bus Stop",
    //   city: "Ibadan",
    //   isPast: false,
    //   isActive: false,
    // ),
  ];
}