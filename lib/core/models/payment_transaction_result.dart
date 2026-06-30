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