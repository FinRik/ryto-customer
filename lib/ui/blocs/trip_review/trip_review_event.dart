part of "trip_review_bloc.dart";

abstract class TripReviewEvent extends Equatable {}

class SubmitTripReview extends TripReviewEvent {
  final int rating;
  final int driverId;
  final String review;

  SubmitTripReview({
    required this.rating,
    required this.driverId,
    required this.review,
  });

  @override
  List<Object?> get props => [rating, driverId, review];
}

class ResetTripReview extends TripReviewEvent {
  @override
  List<Object?> get props => [];
}
