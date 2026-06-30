import 'package:json_annotation/json_annotation.dart';

part 'passenger.g.dart';

enum PassengerStatus { onTrip, checkedIn }

@JsonSerializable()
class Passenger {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  final double? passengerPickupLat;
  final double? passengerPickupLng;
  final double? passengerDropoffLat;
  final double? passengerDropoffLng;

  Passenger({
    this.firstName,
    this.lastName,
    this.email,

    this.id,
    this.passengerPickupLat,
    this.passengerPickupLng,
    this.passengerDropoffLat,
    this.passengerDropoffLng,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get fullname {
    if ((firstName == null || firstName!.isEmpty) &&
        (lastName == null || lastName!.isEmpty)) {
      return "User";
    }
    return "${firstName ?? ''} ${lastName ?? ''}".trim();
  }

  factory Passenger.fromJson(Map<String, dynamic> json) =>
      _$PassengerFromJson(json);
  Map<String, dynamic> toJson() => _$PassengerToJson(this);
}
