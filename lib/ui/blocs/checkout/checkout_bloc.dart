import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/booking/booking_cost.dart';
import '../../../../core/models/booking/booking_response.dart';
import '../../../../core/models/payment_meta_data.dart';
import '../../../../core/repos/trips_repo.dart';
import '../../../../core/repos/payment_repo.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final TripsRepo repo;
  final PaymentRepo paymentRepo;

  CheckoutBloc({required this.repo, required this.paymentRepo})
    : super(const CheckoutState()) {
    on<CalculateCheckoutCost>(_onCalculateCost);
    on<ConfirmAndPayTrip>(_onConfirmAndPay);
    on<VerifyPayment>(_onVerifyPayment);
  }

  Future<void> _onCalculateCost(
    CalculateCheckoutCost event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.pricingLoading));
    try {
      final res = await repo.fetchBookingCost(event.request);
      if (res != null) {
        emit(
          state.copyWith(
            status: CheckoutStatus.pricingSuccess,
            costSummary: res,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: () => "Failed to fetch cost configuration.",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: () => "Failed to fetch cost configuration.",
        ),
      );
    }
  }

  Future<void> _onConfirmAndPay(
    ConfirmAndPayTrip event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.checkoutLoading));

    if (event.isRegionUs) {
      await _confirmAndPayWithStripe(event, emit);
    } else {
      await _confirmAndPayWithPaystack(event, emit);
    }
  }

  /// US/USD flow: the booking must exist before a PaymentIntent can be
  /// created, since the backend ties the intent (and its amount) to the
  /// booking's transactionId. `CheckoutStatus.success` is only emitted once
  /// StripePaymentService confirms the backend verified the payment, so the
  /// UI never shows "Trip Booked" ahead of that.
  Future<void> _confirmAndPayWithStripe(
    ConfirmAndPayTrip event,
    Emitter<CheckoutState> emit,
  ) async {
    BookingResponse? bookingDetails;
    try {
      bookingDetails = await repo.scheduleTrip(event.bookingRequest);
      if (bookingDetails == null ||
          bookingDetails.bookingId == null ||
          bookingDetails.transactionId == null) {
        throw Exception("Invalid backend application register payload data.");
      }
    } catch (bookingError) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: () =>
              "Unable to create your booking. Please try again.",
        ),
      );
      return;
    }

    final txResult = await paymentRepo.payForBookingWithStripe(
      transactionId: bookingDetails.transactionId!,
    );

    if (!txResult.isSuccess) {
      final msg = txResult.isCancelled
          ? "Payment was cancelled."
          : txResult.reference != null
          ? "Payment was processed, but we couldn't confirm it automatically. Please contact support with reference ${txResult.reference}."
          : "Payment was declined.";
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          verificationStatus: txResult.reference != null
              ? PaymentVerificationStatus.failure
              : state.verificationStatus,
          errorMessage: () => msg,
          bookingResponse: bookingDetails,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CheckoutStatus.success,
        verificationStatus: PaymentVerificationStatus.success,
        verificationMessage: () => "Payment verified successfully!",
        bookingResponse: bookingDetails,
      ),
    );
  }

  /// NGN/Paystack flow: unchanged — payment happens first, then booking is
  /// created, and verification against `/booking/verify-payment` runs in the
  /// background via [VerifyPayment].
  Future<void> _confirmAndPayWithPaystack(
    ConfirmAndPayTrip event,
    Emitter<CheckoutState> emit,
  ) async {
    final txResult = await paymentRepo.makePaymentWithPaystack(
      event.paymentMeta,
    );

    if (!txResult.isSuccess) {
      final msg = txResult.isCancelled
          ? "Payment was cancelled."
          : "Payment was declined.";
      emit(
        state.copyWith(status: CheckoutStatus.failure, errorMessage: () => msg),
      );
      return;
    }

    BookingResponse? bookingDetails;
    try {
      bookingDetails = await repo.scheduleTrip(event.bookingRequest);
      if (bookingDetails == null || bookingDetails.bookingId == null) {
        throw Exception("Invalid backend application register payload data.");
      }
    } catch (bookingError) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: () =>
              "Payment cleared, but booking registration timed out. Any deducted funds will be automatically reversed.",
        ),
      );
      return;
    }

    final finalReference = txResult.reference;
    final finalTransactionId = bookingDetails.transactionId;
    final bookingId = bookingDetails.bookingId;

    if (finalReference == null || finalReference.isEmpty) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: () =>
              "Booking recorded, but missing valid transaction verification reference tags. Please contact support.",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CheckoutStatus.success,
        bookingResponse: bookingDetails,
      ),
    );

    add(
      VerifyPayment(
        bookingId: bookingId!,
        reference: finalReference,
        transactionId: finalTransactionId!,
      ),
    );
  }

  /// NGN/Paystack only — never used for US/USD bookings, which are verified
  /// synchronously inside [_confirmAndPayWithStripe].
  Future<void> _onVerifyPayment(
    VerifyPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      state.copyWith(
        verificationStatus: PaymentVerificationStatus.processing,
        verificationMessage: () => null,
      ),
    );

    try {
      await repo.verifyPayment(
        transactionId: event.transactionId,
        bookingId: int.parse(event.bookingId),
        reference: event.reference,
      );

      emit(
        state.copyWith(
          verificationStatus: PaymentVerificationStatus.success,
          verificationMessage: () => "Payment verified successfully!",
        ),
      );
    } catch (verificationError) {
      emit(
        state.copyWith(
          verificationStatus: PaymentVerificationStatus.failure,
          verificationMessage: () =>
              "Booking recorded, but confirmation validation is pending. Please check active bookings shortly.",
        ),
      );
    }
  }
}
