// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) =>
    BookingRequest(
      tripId: (json['tripId'] as num?)?.toInt(),
      bookingLocation: json['bookingLocation'] as String?,
      vehicleId: (json['vehicleId'] as num?)?.toInt(),
      seats: (json['seats'] as num?)?.toInt(),
      noBaggage: (json['noBaggage'] as bool),
      packageSize: json['packageSize'] as String?,
      packageWeight: (json['packageWeight'] as num?)?.toInt(),
      packageHandlingOptions: (json['packageHandlingOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      packageContent: json['packageContent'] as String?,
      packageRecipientName: json['packageRecipientName'] as String?,
      packageRecipientPhone: json['packageRecipientPhone'] as String?,
      originLocation: json['originLocation'] == null
          ? null
          : LatLng.fromJson(json['originLocation'] as Map<String, dynamic>),
      pickupLocation: json['pickupLocation'] == null
          ? null
          : LatLng.fromJson(json['pickupLocation'] as Map<String, dynamic>),
      dropoffLocation: json['dropoffLocation'] == null
          ? null
          : LatLng.fromJson(json['dropoffLocation'] as Map<String, dynamic>),
      destinationLocation: json['destinationLocation'] == null
          ? null
          : LatLng.fromJson(
              json['destinationLocation'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$BookingRequestToJson(BookingRequest instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'bookingLocation': instance.bookingLocation,
      'vehicleId': instance.vehicleId,
      'seats': instance.seats,
      'noBaggage': instance.noBaggage,
      'packageSize': instance.packageSize,
      'packageWeight': instance.packageWeight,
      'packageHandlingOptions': instance.packageHandlingOptions,
      'packageContent': instance.packageContent,
      'packageRecipientName': instance.packageRecipientName,
      'packageRecipientPhone': instance.packageRecipientPhone,
      'originLocation': instance.originLocation,
      'pickupLocation': instance.pickupLocation,
      'dropoffLocation': instance.dropoffLocation,
      'destinationLocation': instance.destinationLocation,
    };
