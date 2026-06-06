part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserTrips extends BookingsEvent {
  final String status;
  LoadUserTrips(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadTripSummary extends BookingsEvent {
  final String id;
  LoadTripSummary(this.id);

  @override
  List<Object?> get props => [id];
}