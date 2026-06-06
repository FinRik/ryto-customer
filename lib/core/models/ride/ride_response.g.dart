// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideResponse _$RideResponseFromJson(Map<String, dynamic> json) => RideResponse(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Ride.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RideResponseToJson(RideResponse instance) =>
    <String, dynamic>{'data': instance.data, 'meta': instance.meta};
