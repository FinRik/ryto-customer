import 'package:json_annotation/json_annotation.dart';

part 'driver.g.dart';

@JsonSerializable()
class Driver {
  final int id;
  final String? phone;
  final String? email;
  final String? firstName;
  final String? lastName;

  final bool? isVerified;

  final double? averageRating;
  final int? totalTrips;
  final String? profilePicture;

  Driver({
    required this.id,
    this.phone,
    this.email,
    this.firstName,
    this.lastName,
    this.isVerified = false,
    this.averageRating = 0.0,
    this.totalTrips = 0,
    this.profilePicture,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
  Map<String, dynamic> toJson() => _$DriverToJson(this);
}