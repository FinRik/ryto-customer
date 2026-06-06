import 'package:json_annotation/json_annotation.dart';

part 'profile_request.g.dart';

@JsonSerializable()
class ProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? dateOfBirth;
  final String? homeAddress;
  final String? country;
  final String? state;
  final String? city;
  final String? profilePicture;

  ProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.homeAddress,
    this.country,
    this.state,
    this.city,
    this.profilePicture,
  });

  factory ProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileRequestToJson(this);

  /// Creates a copy of this [ProfileRequest] with the given fields replaced.
  ProfileRequest copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? dateOfBirth,
    String? homeAddress,
    String? country,
    String? state,
    String? city,
    String? profilePicture,
  }) {
    return ProfileRequest(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      homeAddress: homeAddress ?? this.homeAddress,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
