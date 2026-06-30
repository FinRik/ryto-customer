import 'package:json_annotation/json_annotation.dart';

part 'lat_lng.g.dart';

@JsonSerializable()
class LatLng {
  final double lat;
  final double lng;
  final String? address;

  LatLng({
    required this.lat,
    required this.lng,
    this.address
  });

  factory LatLng.fromJson(Map<String, dynamic> json) =>
      _$LatLngFromJson(json);

  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  @override
  String toString() => 'LatLng(lat: $lat, lng: $lng, address: $address)';
}