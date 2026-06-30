part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserTrips extends BookingsEvent {
  final String status;
  final Map<String, dynamic> searchParams;

  LoadUserTrips({required this.status, required this.searchParams});

  @override
  List<Object?> get props => [status, searchParams];
}

class LoadTripSummary extends BookingsEvent {
  final String id;
  LoadTripSummary(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadBookingCost extends BookingsEvent {
  final BookingRequest request;
  LoadBookingCost(this.request);

  @override
  List<Object?> get props => [request];
}

class CancelBooking extends BookingsEvent {
  final String reason;
  final int bookingId;
  CancelBooking({required this.reason, required this.bookingId});

  @override
  List<Object?> get props => [reason, bookingId];
}
