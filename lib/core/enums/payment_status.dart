enum PaymentStatus { success, cancelled, failed }

class PaymentResponse {
  final PaymentStatus status;
  final String reference;

  PaymentResponse({required this.status, required this.reference});
}