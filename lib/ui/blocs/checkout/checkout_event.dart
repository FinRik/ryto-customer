part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

class CalculateCheckoutCost extends CheckoutEvent {
  final BookingRequest request;
  const CalculateCheckoutCost(this.request);
  @override
  List<Object?> get props => [request];
}

class ConfirmAndPayTrip extends CheckoutEvent {
  final bool isRegionUs;
  final PaymentMetaData paymentMeta;
  final BookingRequest bookingRequest;

  const ConfirmAndPayTrip({
    required this.isRegionUs,
    required this.paymentMeta,
    required this.bookingRequest,
  });

  @override
  List<Object?> get props => [isRegionUs, paymentMeta, bookingRequest];
}

class VerifyPayment extends CheckoutEvent {
  final int transactionId;
  final String bookingId;
  final String reference;

  const VerifyPayment({
    required this.transactionId,
    required this.bookingId,
    required this.reference,
  });

  @override
  List<Object?> get props => [transactionId, bookingId, reference];
}