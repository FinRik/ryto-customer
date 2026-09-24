// class BookingSummary {
//   final double? offsetDistance;
//   final String? basePricePerSeat;
//   final String? basePrice;
//   final String? totalPrice;
//   final String? finalPrice;
//   final String? packageValue;
//   final String? surge;
//   final String? surgePrice;
//   final String? seatPrice;
//   final String? packagePrice;
//   final double? tripDistance;
//
//   BookingSummary({
//     this.basePrice,
//     this.totalPrice,
//     this.surgePrice,
//     this.seatPrice,
//     this.packagePrice,
//     this.basePricePerSeat,
//     this.finalPrice,
//     this.packageValue,
//     this.surge,
//     this.tripDistance,
//     this.offsetDistance,
//   });
//
//   factory BookingSummary.fromJson(Map<String, dynamic> json) {
//     return BookingSummary(
//       offsetDistance: json['offsetDistance'] != null
//           ? double.tryParse(json['offsetDistance'].toString())
//           : null,
//       basePricePerSeat: json['basePricePerSeat'] as String?,
//       basePrice: json['basePrice'] as String?,
//       totalPrice: json['totalPrice'] as String?,
//       finalPrice: json['finalPrice'] as String?,
//       packageValue: json['packageValue'] as String?,
//       surge: json['surge'] as String?,
//       surgePrice: json['surgePrice'] as String?,
//       seatPrice: json['seatPrice'] as String?,
//       packagePrice: json['packagePrice'] as String?,
//       tripDistance: json['tripDistance'] != null
//           ? double.tryParse(json['tripDistance'].toString())
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "offsetDistance": offsetDistance,
//       "basePricePerSeat": basePricePerSeat,
//       "basePrice": basePrice,
//       "totalPrice": totalPrice,
//       "finalPrice": finalPrice,
//       "packagePrice": packagePrice,
//       "surge": surge,
//       "surgePrice": surgePrice,
//       "seatPrice": seatPrice,
//       "packageValue": packageValue,
//       "tripDistance": tripDistance,
//     };
//   }
// }

// class TripCostSummary {
//   final double? offsetDistance;
//   final String? basePricePerSeat;
//   final String? basePrice;
//   final String? totalPrice;
//   final String? finalPrice;
//   final String? packageValue;
//   final String? surge;
//   final String? surgePrice;
//   final String? seatPrice;
//   final String? packagePrice;
//   final double? tripDistance;
//
//   TripCostSummary({
//     this.basePrice,
//     this.totalPrice,
//     this.surgePrice,
//     this.seatPrice,
//     this.packagePrice,
//     this.basePricePerSeat,
//     this.finalPrice,
//     this.packageValue,
//     this.surge,
//     this.tripDistance,
//     this.offsetDistance,
//   });
//
//   factory TripCostSummary.fromJson(Map<String, dynamic> json) {
//     return TripCostSummary(
//       offsetDistance: json['offsetDistance'] != null
//           ? double.tryParse(json['offsetDistance'].toString())
//           : null,
//       basePricePerSeat: json['basePricePerSeat'] as String?,
//       basePrice: json['basePrice'] as String?,
//       totalPrice: json['totalPrice'] as String?,
//       finalPrice: json['finalPrice'] as String?,
//       packageValue: json['packageValue'] as String?,
//       surge: json['surge'] as String?,
//       surgePrice: json['surgePrice'] as String?,
//       seatPrice: json['seatPrice'] as String?,
//       packagePrice: json['packagePrice'] as String?,
//       tripDistance: json['tripDistance'] != null
//           ? double.tryParse(json['tripDistance'].toString())
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "offsetDistance": offsetDistance,
//       "basePricePerSeat": basePricePerSeat,
//       "basePrice": basePrice,
//       "totalPrice": totalPrice,
//       "finalPrice": finalPrice,
//       "packagePrice": packagePrice,
//       "surge": surge,
//       "surgePrice": surgePrice,
//       "seatPrice": seatPrice,
//       "packageValue": packageValue,
//       "tripDistance": tripDistance,
//     };
//   }
// }

class BookingCost {
  final double? offsetDistanceRaw;
  final double? offsetDistanceFormatted;

  final double? tripDistanceRaw;
  final double? tripDistanceFormatted;

  final PriceDetail? basePricePerSeat;
  final PriceDetail? basePrice;
  final PriceDetail? totalPrice;
  final PriceDetail? finalPrice;
  final PriceDetail? discountPrice;
  final PriceDetail? surgePrice;
  final PriceDetail? seatPrice;
  final PriceDetail? packagePrice;

  final double? surgePercentageRaw;
  final String? surgePercentageFormatted;

  final double? discountPercentageRaw;
  final String? discountPercentageFormatted;

  BookingCost({
    this.offsetDistanceRaw,
    this.offsetDistanceFormatted,
    this.tripDistanceRaw,
    this.tripDistanceFormatted,
    this.basePricePerSeat,
    this.basePrice,
    this.totalPrice,
    this.finalPrice,
    this.discountPrice,
    this.surgePrice,
    this.seatPrice,
    this.packagePrice,
    this.surgePercentageRaw,
    this.surgePercentageFormatted,
    this.discountPercentageRaw,
    this.discountPercentageFormatted,
  });

  factory BookingCost.fromJson(Map<String, dynamic> json) {
    final raw = json['rawValues'] as Map<String, dynamic>? ?? {};
    final formatted = json['formattedValues'] as Map<String, dynamic>? ?? {};

    // Helper to parse double safely
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return BookingCost(
      // Distances
      offsetDistanceRaw: toDouble(raw['offsetDistance']),
      offsetDistanceFormatted: toDouble(formatted['offsetDistance']),
      tripDistanceRaw: toDouble(raw['tripDistance']),
      tripDistanceFormatted: toDouble(formatted['tripDistance']),

      // Surge percentages
      surgePercentageRaw: toDouble(raw['surge']),
      surgePercentageFormatted: formatted['surge']?.toString(),

      // discount percentages
      discountPercentageRaw: toDouble(raw['discount']),
      discountPercentageFormatted: formatted['discount']?.toString(),

      // Financial details mapping raw and formatted together
      basePricePerSeat: PriceDetail.fromValues(raw['basePricePerSeat'], formatted['basePricePerSeat']),
      basePrice: PriceDetail.fromValues(raw['basePrice'], formatted['basePrice']),
      totalPrice: PriceDetail.fromValues(raw['totalPrice'], formatted['totalPrice']),
      finalPrice: PriceDetail.fromValues(raw['finalPrice'], formatted['finalPrice']),
      discountPrice: PriceDetail.fromValues(raw['discountPrice'], formatted['discountPrice']),
      surgePrice: PriceDetail.fromValues(raw['surgePrice'], formatted['surgePrice']),
      seatPrice: PriceDetail.fromValues(raw['seatPrice'], formatted['seatPrice']),
      packagePrice: PriceDetail.fromValues(raw['packagePrice'], formatted['packagePrice']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rawValues': {
        'offsetDistance': offsetDistanceRaw,
        'tripDistance': tripDistanceRaw,
        'surge': surgePercentageRaw,
        'discount': discountPercentageRaw,
        'basePricePerSeat': basePricePerSeat?.raw,
        'basePrice': basePrice?.raw,
        'totalPrice': totalPrice?.raw,
        'finalPrice': finalPrice?.raw,
        'discountPrice': discountPrice?.raw,
        'seatPrice': seatPrice?.raw,
        'packagePrice': packagePrice?.raw,
        'surgePrice': surgePrice?.raw,
      },
      'formattedValues': {
        'offsetDistance': offsetDistanceFormatted,
        'tripDistance': tripDistanceFormatted,
        'surge': surgePercentageFormatted,
        'discount': discountPercentageFormatted,
        'basePricePerSeat': basePricePerSeat?.formatted,
        'basePrice': basePrice?.formatted,
        'totalPrice': totalPrice?.formatted,
        'finalPrice': finalPrice?.formatted,
        'discountPrice': discountPrice?.formatted,
        'seatPrice': seatPrice?.formatted,
        'packagePrice': packagePrice?.formatted,
        'surgePrice': surgePrice?.formatted,
      }
    };
  }
}

class PriceDetail {
  final double? raw;
  final String? formatted;

  PriceDetail({this.raw, this.formatted});

  factory PriceDetail.fromValues(dynamic rawValue, dynamic formattedValue) {
    double? parseRaw(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    return PriceDetail(
      raw: parseRaw(rawValue),
      formatted: formattedValue?.toString(),
    );
  }
}