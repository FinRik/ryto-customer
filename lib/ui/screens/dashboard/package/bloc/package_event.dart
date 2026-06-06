part of 'package_bloc.dart';

abstract class PackageEvent extends Equatable {
  const PackageEvent();
  @override
  List<Object?> get props => [];
}

class FetchRoutesRequested extends PackageEvent {
  final String currency;
  const FetchRoutesRequested(this.currency);

  @override
  List<Object?> get props => [currency];
}

class UpdatePackageProgress extends PackageEvent {
  final BookingRequest partialRequest;
  const UpdatePackageProgress(this.partialRequest);

  @override
  List<Object?> get props => [partialRequest];
}

class FetchAvailablePackageRequested extends PackageEvent {
  final int? passengerSeats;
  final String? departureDate;
  final String? destinationCity;
  final String? originCity;
  const FetchAvailablePackageRequested({
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

class FetchBookingCostRequested extends PackageEvent {}

class BookPackageRequested extends PackageEvent {}