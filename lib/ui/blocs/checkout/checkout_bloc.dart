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

  static const _failedPaymentReason = 'FAILED_PAYMENT';

  CheckoutBloc({required this.repo, required this.paymentRepo})
    : super(const CheckoutState()) {
    on<CalculateCheckoutCost>(_onCalculateCost);
    on<ConfirmAndPayTrip>(_onConfirmAndPay);
    on<CancelBooking>(_onCancelBooking);
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
    // Book-then-pay creates a booking on every attempt, so a double tap
    // would create two bookings. Ignore taps while a checkout is running.
    if (state.status == CheckoutStatus.checkoutLoading) return;

    emit(state.copyWith(status: CheckoutStatus.checkoutLoading));

    if (event.isRegionUs) {
      await _confirmAndPayWithStripe(event, emit);
    } else {
      await _confirmAndPayWithPaystack(event, emit);
    }
  }

  // ---------------------------------------------------------------------------
  // Shared helpers for the book -> pay -> cancel-on-failure flow
  // ---------------------------------------------------------------------------

  /// Step 1: create the booking. Returns null if it could not be created
  /// (nothing has been charged at this point).
  Future<BookingResponse?> _createBooking(BookingRequest request) async {
    try {
      final booking = await repo.scheduleTrip(request);
      if (booking == null ||
          booking.bookingId == null ||
          booking.transactionId == null) {
        throw Exception("Invalid booking payload.");
      }
      return booking;
    } catch (e, st) {
      addError(e, st);
      return null;
    }
  }

  /// Releases a booking whose payment definitively failed. Returns whether
  /// the cancellation succeeded so the caller can tell the user.
  Future<bool> _releaseBooking(String bookingId) async {
    try {
      return await repo.cancelTrip(
        bookingId: int.parse(bookingId),
        reason: _failedPaymentReason,
      );
    } catch (e, st) {
      addError(e, st);
      return false;
    }
  }

  String _withReleaseNote(String message, bool released) => released
      ? message
      : "$message We couldn't release your reservation automatically. "
            "If it still appears in your active bookings, please cancel it there.";

  void _emitBookingFailure(Emitter<CheckoutState> emit) {
    emit(
      state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: () => "Unable to create your booking. Please try again.",
      ),
    );
  }

  void _emitUnconfirmedPayment(Emitter<CheckoutState> emit, String bookingId) {
    emit(
      state.copyWith(
        status: CheckoutStatus.failure,
        verificationStatus: PaymentVerificationStatus.failure,
        errorMessage: () =>
            "We couldn't confirm your payment. If you were charged, please "
            "contact support with booking reference $bookingId.",
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // US / USD: Stripe
  // ---------------------------------------------------------------------------

  /// Book -> pay -> cancel if payment fails.
  ///
  /// The booking is created first because the backend ties the PaymentIntent
  /// (and its amount) to the booking's transactionId. If the payment then
  /// fails or is cancelled, the booking is cancelled so no unpaid reservation
  /// is left behind.
  ///
  /// The booking is deliberately NOT cancelled when the outcome is ambiguous
  /// (payment processed but unconfirmed, or an unexpected exception), because
  /// the customer may already have been charged.
  ///
  /// `CheckoutStatus.success` is only emitted once the payment service
  /// confirms the backend verified the payment.
  Future<void> _confirmAndPayWithStripe(
    ConfirmAndPayTrip event,
    Emitter<CheckoutState> emit,
  ) async {
    // 1. Book
    final booking = await _createBooking(event.bookingRequest);
    if (booking == null) {
      _emitBookingFailure(emit);
      return;
    }

    final bookingId = booking.bookingId!;

    try {
      // 2. Pay
      final txResult = await paymentRepo.payForBookingWithStripe(
        event.paymentMeta,
      );

      if (!txResult.isSuccess) {
        // Processed but not confirmed: money may have moved. Keep the booking.
        if (txResult.reference != null) {
          emit(
            state.copyWith(
              status: CheckoutStatus.failure,
              verificationStatus: PaymentVerificationStatus.failure,
              errorMessage: () =>
                  "Payment was processed, but we couldn't confirm it automatically. "
                  "Please contact support with reference ${txResult.reference}.",
            ),
          );
          return;
        }

        // 3. Cancelled or declined: release the booking.
        final released = await _releaseBooking(bookingId);
        final base = txResult.isCancelled
            ? "Payment was cancelled."
            : "Payment was declined.";
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: () => _withReleaseNote(base, released),
          ),
        );
        return;
      }

      final reference = txResult.reference;
      if (reference == null || reference.isEmpty) {
        // Paid, but no reference to verify with. Never cancel a paid booking.
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: () =>
                "Your payment went through, but we're missing its verification "
                "reference. Please contact support with booking reference $bookingId.",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          verificationStatus: PaymentVerificationStatus.success,
          verificationMessage: () => "Payment verified successfully!",
          bookingResponse: booking,
        ),
      );
    } catch (e, st) {
      // Unknown outcome: do not cancel, the charge may have gone through.
      addError(e, st);
      _emitUnconfirmedPayment(emit, bookingId);
    }
  }

  // ---------------------------------------------------------------------------
  // NGN: Paystack
  // ---------------------------------------------------------------------------

  /// Book -> pay -> cancel if payment fails, then verify in the background.
  Future<void> _confirmAndPayWithPaystack(
    ConfirmAndPayTrip event,
    Emitter<CheckoutState> emit,
  ) async {
    // 1. Book
    final booking = await _createBooking(event.bookingRequest);
    if (booking == null) {
      _emitBookingFailure(emit);
      return;
    }
    final bookingId = booking.bookingId!;
    final transactionId = booking.transactionId!;

    try {
      // 2. Pay
      final txResult = await paymentRepo.makePaymentWithPaystack(
        request: event.paymentMeta,
        bookingId: int.parse(bookingId),
        transactionId: transactionId,
      );

      if (!txResult.isSuccess) {
        // 3. Cancelled or declined: release the booking.
        final released = await _releaseBooking(bookingId);
        final base = txResult.isCancelled
            ? "Payment was cancelled."
            : "Payment was declined.";
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: () => _withReleaseNote(base, released),
          ),
        );
        return;
      }

      final reference = txResult.reference;
      if (reference == null || reference.isEmpty) {
        // Paid, but no reference to verify with. Never cancel a paid booking.
        emit(
          state.copyWith(
            status: CheckoutStatus.failure,
            errorMessage: () =>
                "Your payment went through, but we're missing its verification "
                "reference. Please contact support with booking reference $bookingId.",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          verificationStatus: PaymentVerificationStatus.success,
          verificationMessage: () => "Payment verified successfully!",
          bookingResponse: booking,
        ),
      );
    } catch (e, st) {
      // Unknown outcome: do not cancel, the charge may have gone through.
      addError(e, st);
      _emitUnconfirmedPayment(emit, bookingId);
    }
  }

  /// Explicit cancellation (e.g. user-initiated). Payment-failure cleanup is
  /// done inline via [_releaseBooking] so it finishes before the failure is
  /// shown.
  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      await repo.cancelTrip(bookingId: event.bookingId, reason: event.reason);
    } catch (e, st) {
      addError(e, st);
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: () =>
              "We couldn't cancel your booking. Please try again.",
        ),
      );
    }
  }
}
