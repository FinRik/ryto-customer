import 'package:json_annotation/json_annotation.dart';

import '../meta.dart';
import 'ride.dart';

part 'ride_response.g.dart';

@JsonSerializable()
class RideResponse {
  final List<Ride>? data;
  final Meta? meta;

  RideResponse({
    required this.data,
    required this.meta,
  });

  factory RideResponse.fromJson(Map<String, dynamic> json) =>
      _$RideResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RideResponseToJson(this);
}