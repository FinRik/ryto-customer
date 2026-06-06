import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/booking/booking_request.dart';
import '../../../core/models/booking/booking_summary.dart';
import '../../../core/repos/trips_repo.dart';

part 'booking_cost_state.dart';

class BookingCostCubit extends Cubit<BookingCostState> {
  final TripsRepo tripsRepo;

  BookingCostCubit(this.tripsRepo) : super(BookingCostLoading());

  void calculateCost(BookingRequest request) async {
    emit(BookingCostLoading());
    try {
      final summary = await tripsRepo.fetchBookingCost(request);
      if (summary != null) {
        emit(BookingCostLoaded(summary));
      } else {
        emit(BookingCostError("Could not calculate cost. Check connection."));
      }
    } catch (e) {
      emit(BookingCostError(e.toString()));
    }
  }
}
