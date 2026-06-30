import '../models/payment_meta_data.dart';
import '../models/payment_transaction_result.dart';
import '../services/paystack_payment_service.dart';
import '../services/stripe_payment_service.dart';

abstract class PaymentRepo {
  Future<PaymentTransactionResult> makePayment({
    required bool isRegionUS,
    required PaymentMetaData request,
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
  Future<PaymentTransactionResult> makePayment({
    required bool isRegionUS,
    required PaymentMetaData request,
  }) async {
    if (isRegionUS) {
      return await _stripeService.makePayment(request);
    } else {
      return await _payStackService.makePayment(request);
    }
  }
}
