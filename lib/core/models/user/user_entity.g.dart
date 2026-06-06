// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  phoneVerifiedAt: json['phoneVerifiedAt'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  homeAddress: json['homeAddress'] as String?,
  country: json['country'] as String?,
  state: json['state'] as String?,
  city: json['city'] as String?,
  profilePicture: json['profilePicture'] as String?,
  status: json['status'] as String,
  role: json['role'] as String,
  displayName: json['displayName'] as String?,
  identityVerified: json['identityVerified'] as bool,
  licenseVerified: json['licenseVerified'] as bool,
);

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'phoneVerifiedAt': instance.phoneVerifiedAt,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth,
      'homeAddress': instance.homeAddress,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'profilePicture': instance.profilePicture,
      'status': instance.status,
      'role': instance.role,
      'displayName': instance.displayName,
      'identityVerified': instance.identityVerified,
      'licenseVerified': instance.licenseVerified,
    };
