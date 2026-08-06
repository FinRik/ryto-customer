import '../models/payment_meta_data.dart';
import '../models/payment_transaction_result.dart';
import '../services/paystack_payment_service.dart';
import '../services/stripe_payment_service.dart';

abstract class PaymentRepo {
  /// NGN/Paystack — charges [request] directly, ahead of booking creation.
  Future<PaymentTransactionResult> makePaymentWithPaystack(
    PaymentMetaData request,
  );

  /// US/Stripe — must be called after the booking is created, using its
  /// transactionId. Handles PaymentIntent creation, the payment sheet, and
  /// backend verification internally.
  Future<PaymentTransactionResult> payForBookingWithStripe({
    required int transactionId,
  });
}

class PaymentRepoImpl implements PaymentRepo {
  final PayStackPaymentService _payStackService;
  final StripePaymentService _stripeService;

  PaymentRepoImpl({
    required PayStackPaymentService payStackService,
    required StripePaymentService stripeService,
  }) : _payStackService = payStackService,
       _stripeService = stripeService;

  @override
  Future<PaymentTransactionResult> makePaymentWithPaystack(
    PaymentMetaData request,
  ) {
    return _payStackService.makePayment(request);
  }

  @override
  Future<PaymentTransactionResult> payForBookingWithStripe({
    required int transactionId,
  }) {
    return _stripeService.payForBooking(transactionId: transactionId);
  }
}
