import 'package:json_annotation/json_annotation.dart';

import '../lat_lng.dart';

part 'booking_request.g.dart';

@JsonSerializable()
class BookingRequest {
  // for package booking
  final int? tripId;

  final String? bookingLocation;
  final int? vehicleId;
  final int? seats;
  final bool noBaggage;

  // start package
  final String? packageSize;
  final int? packageWeight;
  final List<String>? packageHandlingOptions;
  final String? packageContent;
  // end package

  //start recipient details
  final String? packageRecipientName;
  final String? packageRecipientPhone;
  // end recipient package

  final LatLng? originLocation;
  final LatLng? pickupLocation;
  final LatLng? dropoffLocation;
  final LatLng? destinationLocation;

  BookingRequest({
    this.tripId,
    this.bookingLocation,
    this.vehicleId,
    this.seats,
    this.noBaggage = false,
    this.packageSize,
    this.packageWeight,
    this.packageHandlingOptions,
    this.packageContent,
    this.packageRecipientName,
    this.packageRecipientPhone,
    this.originLocation,
    this.pickupLocation,
    this.dropoffLocation,
    this.destinationLocation,
  });

  BookingRequest copyWith({
    int? tripId,
    String? bookingLocation,
    int? vehicleId,
    int? seats,
    bool? noBaggage,
    String? packageSize,
    int? packageWeight,
    List<String>? packageHandlingOptions,
    String? packageContent,
    String? packageRecipientName,
    String? packageRecipientPhone,
    LatLng? originLocation,
    LatLng? pickupLocation,
    LatLng? dropoffLocation,
    LatLng? destinationLocation,
  }) {
    return BookingRequest(
      tripId: tripId ?? this.tripId,
      bookingLocation: bookingLocation ?? this.bookingLocation,
      vehicleId: vehicleId ?? this.vehicleId,
      seats: seats ?? this.seats,
      noBaggage: noBaggage ?? this.noBaggage,
      packageSize: packageSize ?? this.packageSize,
      packageWeight: packageWeight ?? this.packageWeight,
      packageHandlingOptions:
      packageHandlingOptions ?? this.packageHandlingOptions,
      packageContent: packageContent ?? this.packageContent,
      packageRecipientName: packageRecipientName ?? this.packageRecipientName,
      packageRecipientPhone: packageRecipientPhone ?? this.packageRecipientPhone,
      originLocation: originLocation ?? this.originLocation,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
    );
  }

  factory BookingRequest.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookingRequestToJson(this);

  @override
  String toString() {
    return 'BookingRequest(tripId: $tripId, bookingLocation: $bookingLocation, vehicleId: $vehicleId, seats: $seats, noBaggage: $noBaggage, packageSize: $packageSize, packageWeight: $packageWeight, packageHandlingOptions: $packageHandlingOptions, packageContent: $packageContent, packageRecipientName: $packageRecipientName, packageRecipientPhone: $packageRecipientPhone, originLocation: $originLocation, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, destinationLocation: $destinationLocation)';
  }
}