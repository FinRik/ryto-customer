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

class CancelBooking extends CheckoutEvent {
  final int bookingId;
  final String reason;

  const CancelBooking({
    required this.bookingId,
    required this.reason,
  });

  @override
  List<Object?> get props => [bookingId, reason];
}