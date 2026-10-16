import '../enums/payment_status.dart';

class PaymentTransactionResult {
  final PaymentStatus status;
  final String? reference;

  const PaymentTransactionResult({
    required this.status,
    this.reference,
  });

  bool get isSuccess => status == PaymentStatus.success;
  bool get isCancelled => status == PaymentStatus.cancelled;
}

class PaystackPaymentVerification {
  final int transactionId;
  final int bookingId;
  final String bookingStatus;
  final String transactionStatus;
  final double amountPaid;
  final String currency;
  final String paystackReference;
  final bool alreadyVerified;

  PaystackPaymentVerification({
    required this.transactionId,
    required this.bookingId,
    required this.bookingStatus,
    required this.transactionStatus,
    required this.amountPaid,
    required this.currency,
    required this.paystackReference,
    required this.alreadyVerified,
  });

  factory PaystackPaymentVerification.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaystackPaymentVerification(
      transactionId: json['transactionId'] as int,
      bookingId: json['bookingId'] as int,
      bookingStatus: json['bookingStatus'] as String,
      transactionStatus: json['transactionStatus'] as String,
      amountPaid: (json['amountPaid'] as num).toDouble(),
      currency: json['currency'] as String,
      paystackReference: json['paystackReference'] as String,
      alreadyVerified: json['alreadyVerified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'bookingId': bookingId,
      'bookingStatus': bookingStatus,
      'transactionStatus': transactionStatus,
      'amountPaid': amountPaid,
      'currency': currency,
      'paystackReference': paystackReference,
      'alreadyVerified': alreadyVerified,
    };
  }
}