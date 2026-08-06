import 'package:ryto_customer/core/enums/payment_status.dart';

import '../../../../core/models/payment_meta_data.dart';
import '../../../../core/models/payment_transaction_result.dart';
import '../../../../core/repos/payment_repo.dart';

class MockPaymentRepo implements PaymentRepo {
  @override
  Future<PaymentTransactionResult> makePaymentWithPaystack(
    PaymentMetaData request,
  ) async {
    // Simulate a brief network delay for the payment step
    await Future.delayed(const Duration(milliseconds: 800));

    // Return a successful transaction payload
    return PaymentTransactionResult(
      status: PaymentStatus.success,
      reference: "MOCK_REF_${DateTime.now().millisecondsSinceEpoch}",
    );
  }

  @override
  Future<PaymentTransactionResult> payForBookingWithStripe({
    required int transactionId,
  }) async {
    // Simulate PaymentIntent creation + payment sheet + backend verification
    await Future.delayed(const Duration(milliseconds: 800));

    return PaymentTransactionResult(
      status: PaymentStatus.success,
      reference: "MOCK_PI_${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}
