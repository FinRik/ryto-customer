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

    final txResult = await paymentRepo.makePayment(
      isRegionUS: event.isRegionUs,
      request: event.paymentMeta,
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

  // Future<void> _onVerifyPayment(
  //   VerifyPayment event,
  //   Emitter<CheckoutState> emit,
  // ) async {
  //   emit(
  //     state.copyWith(
  //       paymentStatus: PaymentStatus.processing,
  //       verificationMessage: () => null,
  //     ),
  //   );
  //
  //   try {
  //     await repo.verifyPayment(
  //       transactionId: event.transactionId,
  //       bookingId: int.parse(event.bookingId),
  //       reference: event.reference,
  //     );
  //
  //     emit(
  //       state.copyWith(
  //         paymentStatus: PaymentStatus.success,
  //         verificationMessage: () => "Payment verified successfully!",
  //       ),
  //     );
  //   } catch (verificationError) {
  //     emit(
  //       state.copyWith(
  //         paymentStatus: PaymentStatus.failure,
  //         verificationMessage: () =>
  //             "Booking recorded, but validation is pending. Please check active bookings shortly.",
  //       ),
  //     );
  //   }
  // }

  // inside CheckoutBloc mapping register constructor:
  // on<VerifyPayment>(_onVerifyPayment);

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
