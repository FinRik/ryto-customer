part of "trip_review_bloc.dart";

enum TripReviewStatus { initial, loading, success, failure }

class TripReviewState extends Equatable {
  final TripReviewStatus status;
  final String? errorMessage;

  const TripReviewState({
    this.status = TripReviewStatus.initial,
    this.errorMessage,
  });

  TripReviewState copyWith({
    TripReviewStatus? status,
    String? errorMessage,
  }) {
    return TripReviewState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
