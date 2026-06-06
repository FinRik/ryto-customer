// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => Ride(
  id: (json['id'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  departureDate: json['departureDate'] == null
      ? null
      : DateTime.parse(json['departureDate'] as String),
  departureTime: json['departureTime'] as String?,
  destinationCity: json['destinationCity'] as String?,
  destinationLat: (json['destinationLat'] as num?)?.toDouble(),
  destinationLng: (json['destinationLng'] as num?)?.toDouble(),
  dropoffLat: (json['dropoffLat'] as num?)?.toDouble(),
  dropoffLng: (json['dropoffLng'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  originCity: json['originCity'] as String?,
  originLat: (json['originLat'] as num?)?.toDouble(),
  originLng: (json['originLng'] as num?)?.toDouble(),
  packagesAllowed: json['packagesAllowed'] as bool?,
  passengerSeats: (json['passengerSeats'] as num?)?.toInt(),
  pickupLat: (json['pickupLat'] as num?)?.toDouble(),
  pickupLng: (json['pickupLng'] as num?)?.toDouble(),
  status: json['status'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  driver: json['driver'] == null
      ? null
      : Driver.fromJson(json['driver'] as Map<String, dynamic>),
  vehicle: json['vehicle'] == null
      ? null
      : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
  passengers: (json['passengers'] as List<dynamic>?)
      ?.map((e) => Passenger.fromJson(e as Map<String, dynamic>))
      .toList(),
  // pricePerSeat: (json['pricePerSeat'] as num?)?.toInt(),
);

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt?.toIso8601String(),
  'departureDate': instance.departureDate?.toIso8601String(),
  'departureTime': instance.departureTime,
  'destinationCity': instance.destinationCity,
  'destinationLat': instance.destinationLat,
  'destinationLng': instance.destinationLng,
  'dropoffLat': instance.dropoffLat,
  'dropoffLng': instance.dropoffLng,
  'notes': instance.notes,
  'originCity': instance.originCity,
  'originLat': instance.originLat,
  'originLng': instance.originLng,
  'packagesAllowed': instance.packagesAllowed,
  'passengerSeats': instance.passengerSeats,
  'pickupLat': instance.pickupLat,
  'pickupLng': instance.pickupLng,
  'status': instance.status,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'driver': instance.driver,
  'vehicle': instance.vehicle,
  'passengers': instance.passengers,
  // 'pricePerSeat': instance.pricePerSeat,
};
