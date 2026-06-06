import 'package:json_annotation/json_annotation.dart';

import 'driver.dart';
import 'passenger.dart';
import 'vehicle.dart';
import 'ride.dart';

part 'ride_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class RideSummary extends Ride {
  final Booking? booking;
  final String? safetyPin;

  RideSummary({
    required super.id,
    super.createdAt,
    super.departureDate,
    super.departureTime,
    super.destinationCity,
    super.destinationLat,
    super.destinationLng,
    super.dropoffLat,
    super.dropoffLng,
    super.notes,
    super.originCity,
    super.originLat,
    super.originLng,
    super.packagesAllowed,
    super.passengerSeats,
    super.pickupLat,
    super.pickupLng,
    super.status,
    super.updatedAt,
    super.driver,
    super.vehicle,
    super.passengers,
    this.booking,
    this.safetyPin,
  });

  bool get isTripPending => status == "PENDING" || status == "SCHEDULED";
  bool get isTripBooked => status == "BOOKED";
  bool get isTripApproved => status == "DRIVER_ACCEPTED";
  bool get isTripRejected => status == "DRIVER_REJECTED";
  bool get isTripStarted => status == "TRIP_STARTED";
  bool get isTripCompleted => status == "TRIP_COMPLETED";

  List<String> statuses = [
    "SCHEDULED"
    "BOOKED",
    "DRIVER_ACCEPTED",
    "DRIVER_REJECTED",
    "TRIP_STARTED",
    "TRIP_COMPLETED",
  ];

  factory RideSummary.fromJson(Map<String, dynamic> json) =>
      _$RideSummaryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RideSummaryToJson(this);
}

@JsonSerializable()
class Booking {
  final int id;
  final String status;

  Booking({required this.id, required this.status});

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
