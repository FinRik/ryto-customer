import '../models/payment_meta_data.dart';
import '../models/payment_transaction_result.dart';
import '../services/paystack_payment_service.dart';
import '../services/stripe_payment_service.dart';

abstract class PaymentRepo {
  /// NGN/Paystack — charges [request] directly, ahead of booking creation.
  Future<PaymentTransactionResult> makePaymentWithPaystack({
    required PaymentMetaData request,
    required int transactionId,
    required int bookingId,
  });

  /// US/Stripe — must be called after the booking is created
  Future<PaymentTransactionResult> payForBookingWithStripe(
    PaymentMetaData request,
  );
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
  Future<PaymentTransactionResult> makePaymentWithPaystack({
    required PaymentMetaData request,
    required int transactionId,
    required int bookingId,
  }) {
    return _payStackService.payForBooking(
      request: request,
      transactionId: transactionId,
      bookingId: bookingId,
    );
  }

  @override
  Future<PaymentTransactionResult> payForBookingWithStripe(
    PaymentMetaData request,
  ) {
    return _stripeService.payForBooking(request);
  }
}
