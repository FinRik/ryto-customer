import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  final String color;
  final String makeModel;
  final String type;
  final int year;

  final int? id;
  final int? passengerSeats;
  final String? serviceTier;
  final String? plateNumber;

  Vehicle({
    required this.color,
    required this.makeModel,
    required this.type,
    required this.year,

    this.id,
    this.passengerSeats,
    this.serviceTier,
    this.plateNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}