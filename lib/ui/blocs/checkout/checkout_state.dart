part of 'checkout_bloc.dart';

// enum CheckoutStatus {
//   initial,
//   pricingLoading,
//   pricingSuccess,
//   checkoutLoading,
//   success,
//   failure,
// }
// enum PaymentStatus { initial, processing, success, failure }
//
// class CheckoutState extends Equatable {
//   final CheckoutStatus status;
//   final PaymentStatus paymentStatus;
//   final BookingCost? costSummary;
//   final BookingResponse? bookingResponse;
//   final String? errorMessage;
//   final String? verificationMessage;
//
//   const CheckoutState({
//     this.status = CheckoutStatus.initial,
//     this.paymentStatus = PaymentStatus.initial,
//     this.costSummary,
//     this.bookingResponse,
//     this.errorMessage,
//     this.verificationMessage,
//   });
//
//   CheckoutState copyWith({
//     CheckoutStatus? status,
//     PaymentStatus? paymentStatus,
//     BookingCost? costSummary,
//     BookingResponse? bookingResponse,
//     String? errorMessage,
//     ValueGetter<String?>? verificationMessage,
//   }) {
//     return CheckoutState(
//       status: status ?? this.status,
//       paymentStatus: paymentStatus ?? this.paymentStatus,
//       costSummary: costSummary ?? this.costSummary,
//       bookingResponse: bookingResponse ?? this.bookingResponse,
//       errorMessage: errorMessage,
//       verificationMessage: verificationMessage != null ? verificationMessage() : this.verificationMessage,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     status,
//     paymentStatus,
//     costSummary,
//     bookingResponse,
//     errorMessage,
//     verificationMessage
//   ];
// }


enum CheckoutStatus { initial, pricingLoading, pricingSuccess, checkoutLoading, success, failure }
enum PaymentVerificationStatus { initial, processing, success, failure }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final PaymentVerificationStatus verificationStatus; // New independent status
  final BookingCost? costSummary;
  final BookingResponse? bookingResponse;
  final String? errorMessage;
  final String? verificationMessage; // Specialized background string

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.verificationStatus = PaymentVerificationStatus.initial,
    this.costSummary,
    this.bookingResponse,
    this.errorMessage,
    this.verificationMessage,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    PaymentVerificationStatus? verificationStatus,
    BookingCost? costSummary,
    BookingResponse? bookingResponse,
    ValueGetter<String?>? errorMessage,
    ValueGetter<String?>? verificationMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      costSummary: costSummary ?? this.costSummary,
      bookingResponse: bookingResponse ?? this.bookingResponse,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      verificationMessage: verificationMessage != null ? verificationMessage() : this.verificationMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    verificationStatus,
    costSummary,
    bookingResponse,
    errorMessage,
    verificationMessage,
  ];
}