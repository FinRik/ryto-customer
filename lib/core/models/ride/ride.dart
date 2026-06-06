import 'package:json_annotation/json_annotation.dart';

import '../lat_lng.dart';
import 'driver.dart';
import 'passenger.dart';
import 'vehicle.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride {
  final int id;
  final DateTime? createdAt;
  final DateTime? departureDate;
  final String? departureTime;
  final String? destinationCity;
  final double? destinationLat;
  final double? destinationLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? notes;
  final String? originCity;
  final double? originLat;
  final double? originLng;
  final bool? packagesAllowed;
  final int? passengerSeats;
  final double? pickupLat;
  final double? pickupLng;
  final String? status;
  final DateTime? updatedAt;
  final Driver? driver;
  final Vehicle? vehicle;
  final List<Passenger>? passengers;

  Ride({
    required this.id,
    this.createdAt,
    this.departureDate,
    this.departureTime,
    this.destinationCity,
    this.destinationLat,
    this.destinationLng,
    this.dropoffLat,
    this.dropoffLng,
    this.notes,
    this.originCity,
    this.originLat,
    this.originLng,
    this.packagesAllowed,
    this.passengerSeats,
    this.pickupLat,
    this.pickupLng,
    this.status,
    this.updatedAt,
    this.driver,
    this.vehicle,
    this.passengers,
  });

  LatLng get originCoord =>
      LatLng(lat: originLat ?? 0.0, lng: originLng ?? 0.0);
  LatLng get destCoord =>
      LatLng(lat: destinationLat ?? 0.0, lng: destinationLng ?? 0.0);
  LatLng get pickupCoord =>
      LatLng(lat: pickupLat ?? 0.0, lng: pickupLng ?? 0.0);
  LatLng get dropOffCoord =>
      LatLng(lat: dropoffLat ?? 0.0, lng: dropoffLng ?? 0.0);

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);
  Map<String, dynamic> toJson() => _$RideToJson(this);
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
