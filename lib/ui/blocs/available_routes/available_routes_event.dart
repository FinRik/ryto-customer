part of 'available_routes_bloc.dart';

// --- Events ---
abstract class AvailableTripsEvent extends Equatable {
  const AvailableTripsEvent();
  @override
  List<Object?> get props => [];
}

class FetchTripsAndCosts extends AvailableTripsEvent {
  final Map<String, dynamic> searchParams;
  const FetchTripsAndCosts(this.searchParams);
  
  @override
  List<Object?> get props => [searchParams];
}

class FetchPopularRoutes extends AvailableTripsEvent {
  final String currency;
  const FetchPopularRoutes(this.currency);

  @override
  List<Object?> get props => [currency];
}