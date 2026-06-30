import 'package:json_annotation/json_annotation.dart';

import '../../../utils/helpers/date_time_helper.dart';
import '../lat_lng.dart';
import 'driver.dart';
import 'passenger.dart';
import 'vehicle.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride {
  final int id;
  final DateTime? createdAt;

  @JsonKey(
    readValue: _readDateTimeFields,
    fromJson: _dateTimeFromJson,
    includeToJson: false,
    // includeFromJson: false
  )
  final DateTime departureDateTime;

  final String destinationCity;
  final double destinationLat;
  final double destinationLng;
  final double dropoffLat;
  final double dropoffLng;
  final String? notes;
  final String originCity;
  final double originLat;
  final double originLng;
  final bool? packagesAllowed;
  final int? passengerSeats;
  final double pickupLat;
  final double pickupLng;
  final String? status;
  final DateTime? updatedAt;
  final Driver? driver;
  final Vehicle? vehicle;
  final List<Passenger>? passengers;

  Ride({
    required this.id,
    this.createdAt,
    required this.departureDateTime,
    required this.destinationCity,
    required this.destinationLat,
    required this.destinationLng,
    required this.dropoffLat,
    required this.dropoffLng,
    this.notes,
    required this.originCity,
    required this.originLat,
    required this.originLng,
    this.packagesAllowed,
    this.passengerSeats,
    required this.pickupLat,
    required this.pickupLng,
    this.status,
    this.updatedAt,
    this.driver,
    this.vehicle,
    this.passengers,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  LatLng get originCoord => LatLng(lat: originLat, lng: originLng);
  @JsonKey(includeFromJson: false, includeToJson: false)
  LatLng get destCoord => LatLng(lat: destinationLat, lng: destinationLng);
  @JsonKey(includeFromJson: false, includeToJson: false)
  LatLng get pickupCoord => LatLng(lat: pickupLat, lng: pickupLng);
  @JsonKey(includeFromJson: false, includeToJson: false)
  LatLng get dropOffCoord => LatLng(lat: dropoffLat, lng: dropoffLng);

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

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get departureDate {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractDate(departureDateTime.toString());
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get departureTime24 {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractTime(departureDateTime.toString());
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get departureTime {
    if (departureDateTime == null) return "--:--";
    return DateTimeHelper.extractTime12Hour(departureDateTime.toString());
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get friendlyHeaderStatus {
    switch (status?.toUpperCase()) {
      case "PENDING":
      case "SCHEDULED":
        return "Trip Scheduled";
      case "BOOKED":
        return "Trip Booked";
      case "DRIVER_ACCEPTED":
        return "Driver is Assigned";
      case "DRIVER_REJECTED":
        return "Driver Canceled";
      case "CUSTOMER_CANCELED":
        return "You Canceled your booking";
      case "TRIP_STARTED":
        return "Trip En Route";
      case "TRIP_COMPLETED":
        return "Arrived Safely";
      default:
        return "Finding your Trip";
    }
  }

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);
  // Map<String, dynamic> toJson() => _$RideToJson(this);
  Map<String, dynamic> toJson() {
    final map = _$RideToJson(this);

    map['departureDate'] = departureDateTime.toIso8601String().split('T').first;
    map['departureTime'] = "${departureDateTime.hour.toString().padLeft(2, '0')}:${departureDateTime.minute.toString().padLeft(2, '0')}";

    return map;
  }

  @override
  String toString() {
    return 'Ride(id: $id, createdAt: $createdAt, departureDateTime: $departureDateTime, '
        'destinationCity: $destinationCity, destinationLat: $destinationLat, destinationLng: $destinationLng, '
        'dropoffLat: $dropoffLat, dropoffLng: $dropoffLng, notes: $notes, originCity: $originCity, '
        'originLat: $originLat, originLng: $originLng, packagesAllowed: $packagesAllowed, '
        'passengerSeats: $passengerSeats, pickupLat: $pickupLat, pickupLng: $pickupLng, '
        'status: $status, updatedAt: $updatedAt, driver: $driver, vehicle: $vehicle, passengers: $passengers)';
  }
}

extension RideX on Ride {
  String get avatarText =>
      (driver?.firstName?.isNotEmpty == true) &&
          (driver?.lastName?.isNotEmpty == true)
      ? driver!.firstName![0] + driver!.lastName![0]
      : "U";
  String get driverName =>
      "${driver?.firstName ?? 'Unknown'} ${driver?.lastName ?? ''}";
  bool get isVerified => driver?.isVerified ?? false;
  double get rating => driver?.averageRating ?? 0.0;
  int get tripCount => driver?.totalTrips ?? 0;
  String get vehicleInfo => vehicle?.makeModel ?? '';
}
