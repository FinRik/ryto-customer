import 'package:flutter/material.dart';

import '../enums/payment_status.dart';
import '../models/payment_meta_data.dart';
import '../services/paystack_payment_service.dart';
import '../services/stripe_payment_service.dart';

abstract class PaymentRepo {
  Future<bool> makePayment(bool isRegionUS, BuildContext context, PaymentMetaData request);
}

class PaymentRepoImpl implements PaymentRepo {
  final PaystackPaymentService _payStackService;
  final StripePaymentService _stripeService;

  PaymentRepoImpl({
    required PaystackPaymentService payStackService,
    required StripePaymentService stripeService,
  })  : _payStackService = payStackService,
        _stripeService = stripeService;

  @override
  /// Routes the payment to Stripe or Paystack based on region, returning true if successful.
  Future<bool> makePayment(bool isRegionUS, BuildContext context, PaymentMetaData request) async {
    // 1. Use a ternary operator to dynamically select the correct service
    final status = isRegionUS
        ? await _stripeService.makePayment(request)
        : await _payStackService.makePayment(context, request);

    // 2. Directly return the boolean comparison evaluation
    return status == PaymentStatus.success;
  }
}