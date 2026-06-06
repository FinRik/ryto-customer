import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/models/ride/ride.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/repos/bookings_repo.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BookingsRepo repo;

  BookingsBloc(this.repo) : super(const BookingsState()) {
    on<LoadUserTrips>(_onLoadTrips);
    on<LoadTripSummary>(_onLoadTripSummary);
  }

  Future<void> _onLoadTrips(
    LoadUserTrips event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(status: BookingsStatus.loading));

    try {
      final trips = await repo.fetchUserTrips(event.status);

      emit(
        state.copyWith(
          status: BookingsStatus.success,
          trips: trips?.data ?? [],
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookingsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadTripSummary(
    LoadTripSummary event,
    Emitter<BookingsState> emit,
  ) async {
    final status = state.tripSummary == null
        ? SummaryStatus.loading
        : state.summaryStatus;
    emit(state.copyWith(summaryStatus: status));

    try {
      final summary = await repo.fetchTripSummary(event.id);
      emit(
        state.copyWith(
          summaryStatus: SummaryStatus.success,
          tripSummary: summary,
        ),
      );
    } catch (e) {
      if (state.tripSummary == null) {
        emit(
          state.copyWith(
            summaryStatus: SummaryStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
