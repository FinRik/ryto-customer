import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../app/api_urls.dart';
import '../enums/payment_status.dart';
import '../models/payment_transaction_result.dart';
import '../models/stripe_payment_intent_result.dart';

class StripePaymentService {
  final Dio _dio;

  StripePaymentService(Dio dio) : _dio = dio;

  static String get _publishKey => dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  static void initPublishKey() => Stripe.publishableKey = _publishKey;

  /// Runs the US/Stripe payment flow for an already-created booking:
  /// fetch a backend-issued PaymentIntent for [transactionId], present the
  /// native payment sheet, then ask the backend to verify the result.
  ///
  /// The backend owns the amount and metadata for the PaymentIntent — the
  /// app only ever sends the transactionId.
  Future<PaymentTransactionResult> payForBooking({
    required int transactionId,
  }) async {
    final intent = await _createPaymentIntent(transactionId);
    if (intent == null || intent.paymentIntentId == null) {
      return const PaymentTransactionResult(status: PaymentStatus.failed);
    }

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent.clientSecret,
          merchantDisplayName: 'Ryto Secure Checkout',
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      debugPrint("==> Stripe initPaymentSheet error: $e");
      return const PaymentTransactionResult(status: PaymentStatus.failed);
    }

    final sheetStatus = await _presentPaymentSheet();
    if (sheetStatus != PaymentStatus.success) {
      return PaymentTransactionResult(status: sheetStatus);
    }

    final verified = await _verifyPayment(
      transactionId: transactionId,
      paymentIntentId: intent.paymentIntentId!,
    );

    // Reference stays populated even on a failed verification so callers can
    // tell "card declined" apart from "charged, but confirmation failed".
    return PaymentTransactionResult(
      status: verified ? PaymentStatus.success : PaymentStatus.failed,
      reference: intent.paymentIntentId,
    );
  }

  Future<PaymentStatus> _presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return PaymentStatus.success;
    } on StripeException catch (e) {
      final code = e.error.code;
      final message = e.error.localizedMessage?.toLowerCase() ?? '';

      if (code == FailureCode.Canceled ||
          message.contains('cancel') ||
          message.contains('dismiss')) {
        debugPrint("==> Stripe: user cancelled.");
        return PaymentStatus.cancelled;
      }

      debugPrint(
        "==> Stripe error [${e.error.code}]: ${e.error.localizedMessage}",
      );
      return PaymentStatus.failed;
    } catch (e) {
      debugPrint("==> Generic error presenting Stripe sheet: $e");
      return PaymentStatus.failed;
    }
  }

  /// POST /booking/stripe/payment-intent — authenticated, only sends the
  /// transactionId. The backend controls the amount and currency.
  Future<StripePaymentIntentResult?> _createPaymentIntent(
    int transactionId,
  ) async {
    try {
      final response = await _dio.post(
        ApiUrls.stripePaymentIntent,
        data: {"transactionId": transactionId},
      );

      final body = response.data;
      final payload =
          body is Map<String, dynamic> && body['data'] is Map<String, dynamic>
          ? body['data'] as Map<String, dynamic>
          : body as Map<String, dynamic>?;

      if (payload == null || payload['clientSecret'] == null) {
        debugPrint("==> Stripe: clientSecret missing in response.");
        return null;
      }

      return StripePaymentIntentResult.fromJson(payload);
    } catch (e) {
      debugPrint("==> _createPaymentIntent error: $e");
      return null;
    }
  }

  /// POST /booking/stripe/verify-payment — safe to retry on network failure.
  /// This is the only way "Trip Booked" should ever be shown for a US booking.
  Future<bool> _verifyPayment({
    required int transactionId,
    required String paymentIntentId,
  }) async {
    try {
      await _dio.post(
        ApiUrls.stripeVerifyPayment,
        data: {
          "transactionId": transactionId,
          "paymentIntentId": paymentIntentId,
        },
      );
      return true;
    } catch (e) {
      debugPrint("==> verifyPayment error: $e");
      return false;
    }
  }
}
