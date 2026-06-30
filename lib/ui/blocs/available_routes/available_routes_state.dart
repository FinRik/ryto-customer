part of 'available_routes_bloc.dart';

// --- States ---
enum TripsSearchStatus { initial, loading, success, failure }
enum PopularRoutesStatus { initial, loading, success, failure }

class AvailableTripsState extends Equatable {
  final TripsSearchStatus status;
  final PopularRoutesStatus routesStatus;
  final List<Ride> trips;
  // Map targeting individual ride IDs
  final Map<int, BookingCost> tripCosts;
  final List<PopularRoute> routes;
  final String? errorMessage;

  const AvailableTripsState({
    this.status = TripsSearchStatus.initial,
    this.routesStatus = PopularRoutesStatus.initial,
    this.trips = const [],
    this.tripCosts = const {},
    this.routes = const [],
    this.errorMessage,
  });

  AvailableTripsState copyWith({
    TripsSearchStatus? status,
    List<Ride>? trips,
    Map<int, BookingCost>? tripCosts,
    PopularRoutesStatus? routesStatus,
    List<PopularRoute>? routes,
    String? errorMessage,
  }) {
    return AvailableTripsState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      tripCosts: tripCosts ?? this.tripCosts,
      routesStatus: routesStatus ?? this.routesStatus,
      routes: routes ?? this.routes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    trips,
    tripCosts,
    routesStatus,
    routes,
    errorMessage,
  ];
}
