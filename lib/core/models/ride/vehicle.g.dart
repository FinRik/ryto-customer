// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
  color: json['color'] as String,
  makeModel: json['makeModel'] as String,
  type: json['type'] as String,
  year: (json['year'] as num).toInt(),
  id: (json['id'] as num?)?.toInt(),
  passengerSeats: (json['passengerSeats'] as num?)?.toInt(),
  serviceTier: json['serviceTier'] as String?,
  plateNumber: json['plateNumber'] as String?,
);

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
  'color': instance.color,
  'makeModel': instance.makeModel,
  'type': instance.type,
  'year': instance.year,
  'id': instance.id,
  'passengerSeats': instance.passengerSeats,
  'serviceTier': instance.serviceTier,
  'plateNumber': instance.plateNumber,
};
