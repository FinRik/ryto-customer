part of 'trip_setup_bloc.dart';

enum PopularRoutesStatus { initial, loading, success, failure }
enum AvailableTripsStatus { initial, loading, success, failure }
enum TripSetupStatus { initial, loading, success, failure }

class TripSetupState extends Equatable {
  final BookingRequest request;

  // Data containers
  final List<PopularRoute> routes;
  final List<Ride> availableTrips;
  final Meta? tripsMeta;
  final BookingSummary? costSummary;
  final BookingResponse? scheduleResponse;
  final String? errorMessage;

  // Status Enums
  final PopularRoutesStatus routesStatus;
  final AvailableTripsStatus tripsStatus;
  final TripSetupStatus setupStatus;

  const TripSetupState({
    required this.request,
    this.routes = const [],
    this.availableTrips = const [],
    this.tripsMeta,
    this.costSummary,
    this.scheduleResponse,
    this.errorMessage,
    this.routesStatus = PopularRoutesStatus.initial,
    this.tripsStatus = AvailableTripsStatus.initial,
    this.setupStatus = TripSetupStatus.initial,
  });

  TripSetupState copyWith({
    BookingRequest? request,
    List<PopularRoute>? routes,
    List<Ride>? availableTrips,
    Meta? tripsMeta,
    BookingSummary? costSummary,
    BookingResponse? scheduleResponse,
    String? errorMessage,
    PopularRoutesStatus? routesStatus,
    AvailableTripsStatus? tripsStatus,
    TripSetupStatus? setupStatus,
  }) {
    return TripSetupState(
      request: request ?? this.request,
      routes: routes ?? this.routes,
      availableTrips: availableTrips ?? this.availableTrips,
      tripsMeta: tripsMeta ?? this.tripsMeta,
      costSummary: costSummary ?? this.costSummary,
      scheduleResponse: scheduleResponse ?? this.scheduleResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      routesStatus: routesStatus ?? this.routesStatus,
      tripsStatus: tripsStatus ?? this.tripsStatus,
      setupStatus: setupStatus ?? this.setupStatus,
    );
  }

  @override
  List<Object?> get props => [
    request, routes, availableTrips, tripsMeta,
    costSummary, scheduleResponse, errorMessage,
    routesStatus, tripsStatus, setupStatus
  ];
}