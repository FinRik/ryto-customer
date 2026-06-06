// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
  id: (json['id'] as num).toInt(),
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  isVerified: json['isVerified'] as bool? ?? false,
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
  totalTrips: (json['totalTrips'] as num?)?.toInt() ?? 0,
  profilePicture: json['profilePicture'] as String?,
);

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'isVerified': instance.isVerified,
  'averageRating': instance.averageRating,
  'totalTrips': instance.totalTrips,
  'profilePicture': instance.profilePicture,
};
