import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../app/api_urls.dart';
import '../enums/payment_status.dart';
import '../models/payment_meta_data.dart';
import '../models/payment_transaction_result.dart';

class StripePaymentService {
  final Dio _dio;

  StripePaymentService(Dio dio) : _dio = dio;

  static const _stripeIntentsUrl = '${ApiUrls.stripeBaseUrl}/payment_intents';
  String get _secretKey => dotenv.env['STRIPE_LIVE_SECRET_KEY']!;
  static String get _publishKey => dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  static void initPublishKey() => Stripe.publishableKey = _publishKey;

  // Future<PaymentStatus> makePayment(PaymentMetaData request) async {
  //   try {
  //     final clientResult = await _createPaymentIntent(request);
  //
  //     if (clientResult == null) {
  //       debugPrint("==> Stripe: failed to create payment intent.");
  //       return PaymentStatus.failed;
  //     }
  //
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: clientResult['client_secret'],
  //         customerEphemeralKeySecret: clientResult['ephemeralKey'],
  //         merchantDisplayName: 'Ryto Secure Checkout',
  //         customerId: clientResult['customer'],
  //         style: ThemeMode.light,
  //       ),
  //     );
  //
  //     return await _processPayment();
  //   } catch (e, stacktrace) {
  //     debugPrint("==> makePayment error:}");
  //     debugPrint("==> ${e.toString()}");
  //     debugPrint("==> makePayment stacktrace:");
  //     debugPrint("==> ${stacktrace.toString()}");
  //     return PaymentStatus.failed;
  //   }
  // }

  Future<PaymentTransactionResult> makePayment(PaymentMetaData request) async {
    try {
      final clientResult = await _createPaymentIntent(request);
      if (clientResult == null) {
        return const PaymentTransactionResult(status: PaymentStatus.failed);
      }

      final paymentIntentId = clientResult['id'] as String?;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientResult['client_secret'],
          customerEphemeralKeySecret: clientResult['ephemeralKey'],
          merchantDisplayName: 'Ryto Secure Checkout',
          customerId: clientResult['customer'],
          style: ThemeMode.light,
        ),
      );

      final status = await _processPayment();
      return PaymentTransactionResult(
        status: status,
        reference: paymentIntentId,
      );
    } catch (e) {
      return const PaymentTransactionResult(status: PaymentStatus.failed);
    }
  }

  Future<PaymentStatus> _processPayment() async {
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

  Future<Map<String, dynamic>?> _createPaymentIntent(
    PaymentMetaData request,
  ) async {
    try {
      final response = await _dio.post(
        _stripeIntentsUrl,
        data: {
          "receipt_email": request.email,
          'amount': (request.amount * 100).toInt().toString(),
          'currency': 'usd',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Authorization': 'Bearer $_secretKey'},
          extra: {'bypassErrorInterceptor': true, 'isPublic': true},
        ),
      );

      if (response.statusCode == 200) {
        final result = response.data as Map<String, dynamic>?;
        if (result == null) {
          debugPrint("==> Stripe: client_secret missing in response.");
        }
        return result;
      }

      debugPrint("==> Stripe non-200: ${response.statusCode} ${response.data}");
      return null;
    } on DioException catch (e) {
      // Stripe errors come back as 4xx with a structured body —
      // parse them directly here instead of letting the interceptor crash.
      final stripeError = e.response?.data?['error'];
      debugPrint(
        "==> Stripe API error: ${stripeError?['type']} — ${stripeError?['message']}",
      );
      return null;
    } catch (e) {
      debugPrint("==> _createPaymentIntent unexpected error: $e");
      return null;
    }
  }
}
