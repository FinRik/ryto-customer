import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../app/api_urls.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity extends Equatable {
  final int id;
  final String? email;
  final String? phone;
  final String? phoneVerifiedAt;
  final String? firstName;
  final String? lastName;
  @JsonKey(includeIfNull: true)
  final String? dateOfBirth;
  @JsonKey(includeIfNull: true)
  final String? homeAddress;
  @JsonKey(includeIfNull: true)
  final String? country;
  @JsonKey(includeIfNull: true)
  final String? state;
  @JsonKey(includeIfNull: true)
  final String? city;
  @JsonKey(includeIfNull: true)
  final String? profilePicture;
  final String status;
  final String role;
  final String? displayName;
  final bool identityVerified;
  final bool licenseVerified;

  const UserEntity({
    required this.id,
    this.email,
    this.phone,
    this.phoneVerifiedAt,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.homeAddress,
    this.country,
    this.state,
    this.city,
    this.profilePicture,
    required this.status,
    required this.role,
    this.displayName,
    required this.identityVerified,
    required this.licenseVerified,
  });

  String get fullname {
    if ((firstName == null || firstName!.isEmpty) &&
        (lastName == null || lastName!.isEmpty)) {
      return "User";
    }
    return "${firstName ?? ''} ${lastName ?? ''}".trim();
  }

  double get rating => 0;
  int get reviewCount => 0;
  String get imageUrl => "${ApiUrls.baseUrl}$profilePicture";

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    phoneVerifiedAt,
    firstName,
    lastName,
    dateOfBirth,
    homeAddress,
    country,
    state,
    city,
    profilePicture,
    status,
    role,
    displayName,
    identityVerified,
    licenseVerified,
  ];
}

extension UserEntityExtension on UserEntity {
  UserEntity copyWith({
    int? id,
    String? email,
    String? phone,
    String? phoneVerifiedAt,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? homeAddress,
    String? country,
    String? state,
    String? city,
    String? profilePicture,
    String? status,
    String? role,
    String? displayName,
    bool? identityVerified,
    bool? licenseVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      homeAddress: homeAddress ?? this.homeAddress,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      identityVerified: identityVerified ?? this.identityVerified,
      licenseVerified: licenseVerified ?? this.licenseVerified,
    );
  }
}
