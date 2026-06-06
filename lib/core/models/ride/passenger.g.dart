// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Passenger _$PassengerFromJson(Map<String, dynamic> json) => Passenger(
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  id: (json['id'] as num?)?.toInt(),
  passengerPickupLat: (json['passengerPickupLat'] as num?)?.toDouble(),
  passengerPickupLng: (json['passengerPickupLng'] as num?)?.toDouble(),
  passengerDropoffLat: (json['passengerDropoffLat'] as num?)?.toDouble(),
  passengerDropoffLng: (json['passengerDropoffLng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PassengerToJson(Passenger instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'passengerPickupLat': instance.passengerPickupLat,
  'passengerPickupLng': instance.passengerPickupLng,
  'passengerDropoffLat': instance.passengerDropoffLat,
  'passengerDropoffLng': instance.passengerDropoffLng,
};
