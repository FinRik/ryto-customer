class BookingResponse {
   final String? bookingSafetyPin;
  final int? transactionId;
  final String? paymentUrl;

  BookingResponse({
    this.bookingSafetyPin,
    this.transactionId,
    this.paymentUrl,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookingSafetyPin: json['bookingSafetyPin'] as String?,
      transactionId: json['transactionId'] as int?,
      paymentUrl: json["paymentUrl"] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookingSafetyPin": bookingSafetyPin,
      "transactionId": transactionId,
      "paymentUrl": paymentUrl,
    };
  }
}