import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../enums/payment_status.dart';
import '../models/payment_meta_data.dart';

class StripePaymentService {
  final Dio _dio;

  StripePaymentService(Dio dio) : _dio = dio;

  Future<PaymentStatus> makePayment(PaymentMetaData request) async {
    try {
      String? clientPaymentSecret = await _createPaymentIntent(request.amount);

      if (clientPaymentSecret == null) {
        return PaymentStatus.failed;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientPaymentSecret,
          merchantDisplayName: 'Ryto',
        ),
      );
      return _processPayment();
    } catch (e) {
      return PaymentStatus.failed;
    }
  }

  // Future<PaymentStatus> _processPayment() async {
  //   try {
  //     // Show the payment sheet
  //     await Stripe.instance.presentPaymentSheet();
  //
  //     /// NOTE:
  //     /// Don't use await Stripe.instance.confirmPaymentSheetPayment();
  //     /// because it will throw an error if the payment is successful.
  //     ///* The payment sheet will automatically confirm the payment
  //     ///
  //     return PaymentStatus.success;
  //   } on StripeException catch (e) {
  //     if (e.error.code == FailureCode.Canceled) {
  //       return PaymentStatus.cancelled;
  //     } else {
  //       return PaymentStatus.failed;
  //     }
  //   } catch (_) {
  //     return PaymentStatus.failed;
  //   }
  // }

  Future<PaymentStatus> _processPayment() async {
    try {
      // Show the payment sheet
      await Stripe.instance.presentPaymentSheet();
      return PaymentStatus.success;
    } on StripeException catch (e) {
      // Safely capturing if the user closed the sheet manually
      if (e.error.code == FailureCode.Canceled ||
          e.error.localizedMessage?.toLowerCase().contains('canceled') == true ||
          e.error.localizedMessage?.toLowerCase().contains('cancelled') == true) {
        debugPrint("==> User manually closed the Stripe sheet.");
        return PaymentStatus.cancelled;
      }

      debugPrint("==> Stripe Error: ${e.error.localizedMessage}");
      return PaymentStatus.failed;
    } catch (e) {
      debugPrint("==> Generic Error processing Stripe sheet: $e");
      return PaymentStatus.failed;
    }
  }

  Future<String?> _createPaymentIntent(double amount) async {
    Map<String, dynamic> body = {
      'amount': (amount * 100).toInt().toString(),
      'currency': "USD",
    };

    try {
      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_LIVE_PUBLIC_KEY']}',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        return response.data['client_secret'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
