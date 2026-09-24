import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_setup_locator.dart';
import '../../ui/bottom_sheets/paystack_bottom_sheet.dart';
import '../enums/bottom_sheet_type.dart';
import '../models/base.dart';
import '../models/payment_meta_data.dart';
import '../enums/payment_status.dart';
import '../../app/api_urls.dart';
import '../models/payment_transaction_result.dart';
import 'bottom_sheet_service.dart';

class PayStackPaymentService {
  PayStackPaymentService(Dio dio) : _dio = dio;
  final Dio _dio;

  static const String _initializeUrl =
      "${ApiUrls.paystackUrl}/transaction/initialize";
  // static const String _verifyUrl = "${ApiUrls.paystackUrl}/transaction/verify/";

  String get _secretKey => dotenv.env['PAYSTACK_LIVE_SECRET_KEY']!;
  String get _callbackUrl => dotenv.env['PAYSTACK_CALLBACK_URL']!;

  Options get _authHeaders => Options(
    extra: {'bypassErrorInterceptor': true, 'isPublic': true},
    headers: {
      'Authorization': 'Bearer $_secretKey',
      'Content-Type': 'application/json',
    },
  );

  /// Full payment flow:
  /// 1. Initialize transaction with Paystack API
  /// 2. Show authorization URL in a bottom sheet WebView
  /// 3. Verify on callback intercept
  Future<PaymentTransactionResult> payForBooking({
    required PaymentMetaData request,
    required int transactionId,
    required int bookingId,
  }) async {
    try {
      final initResult = await _initializeTransaction(request);
      if (initResult == null) {
        return const PaymentTransactionResult(status: PaymentStatus.failed);
      }

      final authUrl = initResult['authorization_url'] as String;
      final reference = initResult['reference'] as String;

      final result = await sl<BottomSheetService>()
          .showCustomBottomSheet<WebViewResult, Map<String, String>>(
            variant: BottomSheetType.paystackPayment,
            data: {"authorizationUrl": authUrl},
          );

      if (result == null || result.data == WebViewResult.cancelled) {
        return const PaymentTransactionResult(status: PaymentStatus.cancelled);
      }

      final verificationStatus = await verifyPayment(
        reference,
        transactionId,
        bookingId,
      );
      return PaymentTransactionResult(
        status: verificationStatus,
        reference: reference,
      );
    } catch (e) {
      return const PaymentTransactionResult(status: PaymentStatus.failed);
    }
  }

  Future<Map<String, dynamic>?> _initializeTransaction(
    PaymentMetaData request,
  ) async {
    try {
      final txRef = const Uuid().v4();

      final response = await _dio.post(
        _initializeUrl,
        options: _authHeaders,
        data: {
          'email': request.email,
          'amount': (request.amount * 100),
          'reference': txRef,
          'currency': 'NGN',
          'callback_url': _callbackUrl,
          'metadata': {
            'customer_name': request.name,
            'customer_email': request.email,
            'customer_phone': request.phone,
            'trip_id': request.tripId,
          },
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }

      debugPrint("==> Init failed: ${response.data}");
      return null;
    } catch (e) {
      debugPrint("==> _initializeTransaction error: $e");
      return null;
    }
  }

  Future<PaymentStatus> verifyPayment(
    String reference,
    int transactionId,
    int bookingId,
  ) async {
    try {
      final result = await _dio.post<Map<String, dynamic>>(
        ApiUrls.paystackVerifyPayment,
        options: Options(method: "POST", extra: {'isPublic': false}),
        data: {
          'transactionId': transactionId,
          'bookingId': bookingId,
          'reference': reference,
        },
      );

      if (result.statusCode != 200 || result.data == null) {
        debugPrint(
          '==> Payment verification failed: '
          'HTTP ${result.statusCode}',
        );

        return PaymentStatus.failed;
      }

      final value = BaseModel<PaystackPaymentVerification>.fromJson(
        result.data!,
        (json) =>
            PaystackPaymentVerification.fromJson(json as Map<String, dynamic>),
      );

      final paystackStatus = value.data?.transactionStatus.toLowerCase();

      debugPrint('==> Paystack verify status: $paystackStatus');

      switch (paystackStatus) {
        case 'success':
        case 'completed':
          return PaymentStatus.success;

        case 'abandoned':
        case 'canceled':
        case 'cancelled':
          return PaymentStatus.cancelled;

        case 'failed':
        default:
          return PaymentStatus.failed;
      }
    } catch (e) {
      debugPrint("==> verifyPayment error: $e");
      return PaymentStatus.failed;
    }
  }

  // Future<PaymentStatus> verifyPayment(String reference) async {
  //   try {
  //     final response = await _dio.get(
  //       '$_verifyUrl$reference',
  //       options: _authHeaders,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final paystackStatus = response.data['data']?['status'] as String?;
  //
  //       debugPrint("==> Paystack verify status: $paystackStatus");
  //
  //       switch (paystackStatus) {
  //         case 'success':
  //           return PaymentStatus.success;
  //         case 'abandoned':
  //           return PaymentStatus.cancelled;
  //         case 'failed':
  //         default:
  //           return PaymentStatus.failed;
  //       }
  //     }
  //
  //     return PaymentStatus.failed;
  //   } catch (e) {
  //     debugPrint("==> verifyPayment error: $e");
  //     return PaymentStatus.failed;
  //   }
  // }
}
