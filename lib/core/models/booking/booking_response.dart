class BookingResponse {
   final String? bookingSafetyPin;
  final int? transactionId;
  final String? bookingId;

  BookingResponse({
    this.bookingSafetyPin,
    this.transactionId,
    this.bookingId,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookingSafetyPin: json['bookingSafetyPin'] as String?,
      transactionId: json['transactionId'] as int?,
      bookingId: (json["bookingId"]).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookingSafetyPin": bookingSafetyPin,
      "transactionId": transactionId,
      "bookingId": bookingId,
    };
  }
}