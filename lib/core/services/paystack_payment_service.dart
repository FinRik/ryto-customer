import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

import '../../app/api_urls.dart';
import '../enums/payment_status.dart';
import '../models/payment_meta_data.dart';

class PaystackPaymentService {
  PaystackPaymentService(Dio dio) : _dio = dio;
  final Dio _dio;

  static const String _verifyUrl =
      "${ApiUrls.paystackBaseUrl}/transaction/verify/";

  /// Initiates the Paystack Checkout UI and tracks status via Enum
  Future<PaymentStatus> makePayment(BuildContext context, PaymentMetaData request) async {
    final completer = Completer<PaymentStatus>();
    final txRef = PayWithPayStack().generateUuidV4();

    await PayWithPayStack().now(
      context: context,
      secretKey: dotenv.env['PAYSTACK_LIVE_SECRET_KEY']!,
      customerEmail: request.email,
      reference: txRef,
      currency: "NGN",
      amount: request.amount,
      metaData: {"customer_name": request.name, "trip_id": request.tripId},
      callbackUrl: "https://google.com",
      transactionCompleted: (paymentData) async {
        debugPrint("==> Client UI complete. Verifying transaction: $txRef");

        // Always verify with backend/API before trusting client callback
        final status = await verifyPayment(txRef);
        completer.complete(status);
      },
      transactionNotCompleted: (reason) {
        debugPrint("==> Transaction not completed. Reason: $reason");

        // Paystack SDK returns specific strings for cancellation
        if (reason.toLowerCase().contains('cancel') ||
            reason.toLowerCase().contains('closed')) {
          completer.complete(PaymentStatus.cancelled);
        } else {
          completer.complete(PaymentStatus.failed);
        }
      },
    );

    return completer.future;
  }

  /// Verifies the transaction reference via Paystack API
  Future<PaymentStatus> verifyPayment(String reference) async {
    try {
      final secretKey = dotenv.env['PAYSTACK_LIVE_SECRET_KEY']!;

      final response = await _dio.get(
        '$_verifyUrl$reference',
        options: Options(
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // 'success', 'failed', or 'abandoned'
        final paystackStatus = data['data']?['status'];

        if (data['status'] == true && paystackStatus == 'success') {
          debugPrint("==> Verification successful.");
          return PaymentStatus.success;
        } else if (paystackStatus == 'ongoing' ||
            paystackStatus == 'abandoned') {
          return PaymentStatus.cancelled;
        }
      }

      debugPrint("==> Verification failed response: ${response.data}");
      return PaymentStatus.failed;
    } catch (e) {
      debugPrint("==> Error during verification network request: $e");
      return PaymentStatus.failed;
    }
  }
}
