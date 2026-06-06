part of 'trip_setup_bloc.dart';

abstract class TripSetupEvent extends Equatable {
  const TripSetupEvent();
  @override
  List<Object?> get props => [];
}

class FetchRoutesRequested extends TripSetupEvent {
  final String currency;
  const FetchRoutesRequested(this.currency);

  @override
  List<Object?> get props => [currency];
}

class UpdateTripProgress extends TripSetupEvent {
  final BookingRequest partialRequest;
  const UpdateTripProgress(this.partialRequest);

  @override
  List<Object?> get props => [partialRequest];
}

class FetchAvailableTripsRequested extends TripSetupEvent {
  final int? passengerSeats;
  final String? departureDate;
  final String? destinationCity;
  final String? originCity;
  const FetchAvailableTripsRequested({
    this.passengerSeats,
    this.departureDate,
    this.destinationCity,
    this.originCity,
  });

  @override
  List<Object?> get props => [
    passengerSeats,
    departureDate,
    destinationCity,
    originCity,
  ];
}

class FetchTripCostRequested extends TripSetupEvent {}

class ScheduleTripRequested extends TripSetupEvent {}