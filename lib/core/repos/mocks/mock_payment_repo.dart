import 'package:ryto_customer/core/enums/payment_status.dart';

import '../../../../core/models/payment_meta_data.dart';
import '../../../../core/models/payment_transaction_result.dart';
import '../../../../core/repos/payment_repo.dart';

class MockPaymentRepo implements PaymentRepo {
  @override
  Future<PaymentTransactionResult> makePayment({
    required bool isRegionUS,
    required PaymentMetaData request,
  }) async {
    // Simulate a brief network delay for the payment step
    await Future.delayed(const Duration(milliseconds: 800));

    // Return a successful transaction payload
    return PaymentTransactionResult(
      status: PaymentStatus.success,
      reference: "MOCK_REF_${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}