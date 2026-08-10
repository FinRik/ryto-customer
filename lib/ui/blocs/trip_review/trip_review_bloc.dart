import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/repos/trips_repo.dart';

part 'trip_review_event.dart';
part 'trip_review_state.dart';

class TripReviewBloc extends Bloc<TripReviewEvent, TripReviewState> {
  final TripsRepo repo;

  TripReviewBloc(this.repo) : super(const TripReviewState()) {
    on<SubmitTripReview>(_onSubmitTripReview);
    on<ResetTripReview>(_onResetTripReview);
  }

  Future<void> _onSubmitTripReview(
    SubmitTripReview event,
    Emitter<TripReviewState> emit,
  ) async {
    emit(state.copyWith(status: TripReviewStatus.loading, errorMessage: null));
    try {
      final success = await repo.reviewTrip(
        rating: event.rating,
        driverId: event.driverId,
        review: event.review,
      );

      emit(
        state.copyWith(
          status: success ? TripReviewStatus.success : TripReviewStatus.failure,
          errorMessage: success ? null : "Failed to submit review, please try again",
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TripReviewStatus.failure,
          errorMessage: "Failed to submit review, please try again",
        ),
      );
    }
  }

  void _onResetTripReview(
    ResetTripReview event,
    Emitter<TripReviewState> emit,
  ) {
    emit(const TripReviewState());
  }
}
