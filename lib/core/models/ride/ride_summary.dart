import 'package:json_annotation/json_annotation.dart';

import '../../../utils/helpers/date_time_helper.dart';
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
    required super.departureDateTime,
    required super.destinationCity,
    required super.destinationLat,
    required super.destinationLng,
    required super.dropoffLat,
    required super.dropoffLng,
    super.notes,
    required super.originCity,
    required super.originLat,
    required super.originLng,
    super.packagesAllowed,
    super.passengerSeats,
    required super.pickupLat,
    required super.pickupLng,
    super.status,
    super.updatedAt,
    super.driver,
    super.vehicle,
    super.passengers,
    this.booking,
    this.safetyPin,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTripPending => status == "PENDING" || status == "SCHEDULED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTripBooked => status == "BOOKED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTripApproved => status == "DRIVER_ACCEPTED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTripRejected => status == "DRIVER_REJECTED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTripCanceled => status == "CANCELED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTripStarted => status == "TRIP_STARTED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTripCompleted => status == "COMPLETED";

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isBookingPending => booking?.status == "PENDING";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isBookingBooked => booking?.status == "BOOKED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isBookingApproved => booking?.status == "DRIVER_ACCEPTED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isBookingRejected => booking?.status == "DRIVER_REJECTED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isBookingCanceled => booking?.status == "CUSTOMER_CANCELED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isBookingStarted => booking?.status == "TRIP_STARTED";
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isBookingCompleted => booking?.status == "TRIP_COMPLETED";

  /// Returns a reader-friendly translation of the overall trip status for headers.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String get friendlyHeaderStatus {
    // 1. Check parent ride status first
    if (status == "CANCELED") return "Trip Canceled";
    if (status == "TRIP_COMPLETED") return "Trip Arrived Safely";
    if (status == "TRIP_STARTED") return "Trip in Progress";

    // 2. Check localized booking statuses
    if (isBookingCanceled) return "Request Canceled";
    if (isBookingRejected) return "Request Declined by Driver";
    if (isBookingApproved) return "Driver On The Way";
    if (isBookingPending || isBookingBooked) return "Waiting for Driver's Response";

    return "Booking Processing";
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> get statuses => [
    "SCHEDULED",
    "BOOKED",
    "DRIVER_ACCEPTED",
    "DRIVER_REJECTED",
    "CUSTOMER_CANCELED",
    "TRIP_STARTED",
    "TRIP_COMPLETED",
    "CANCELED",
  ];

  // HELPER: Safely extracts and joins 'YYYY-MM-DD' and 'HH:MM' from JSON map
  static String? _readDateTimeFields(Map json, String key) {
    final date = json['departureDate'] ?? '1970-01-01';
    final time = json['departureTime'] ?? '00:00';
    // Formats into a clean ISO-8601 string
    return '${date}T$time:00';
  }

  // Custom converters for DateTime
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toIso8601String();


  factory RideSummary.fromJson(Map<String, dynamic> json) =>
      _$RideSummaryFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final map = _$RideSummaryToJson(this);
    map['departureDate'] = departureDateTime.toIso8601String().split('T').first;
    map['departureTime'] = "${departureDateTime.hour.toString().padLeft(2, '0')}:${departureDateTime.minute.toString().padLeft(2, '0')}";

    return map;
  }
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
