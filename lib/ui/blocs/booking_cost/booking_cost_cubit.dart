import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/models/booking/booking_request.dart';
import '../../../core/models/booking/booking_cost.dart';
import '../../../core/repos/trips_repo.dart';

class BookingCostCubit extends Cubit<AsyncSnapshot<BookingCost>> {
  final TripsRepo tripsRepo;

  BookingCostCubit(this.tripsRepo) : super(const AsyncSnapshot.waiting());

  void calculateCost(BookingRequest request) async {
    try {
      final cost = await tripsRepo.fetchBookingCost(request);
      if (cost != null) {
        emit(AsyncSnapshot.withData(ConnectionState.done, cost));
      } else {
        emit(
          AsyncSnapshot.withError(
            ConnectionState.done,
            "Could not calculate cost. Pleas try again.",
          ),
        );
      }
    } catch (e) {
      emit(
        AsyncSnapshot.withError(
          ConnectionState.done,
          "Could not calculate cost. Check connection.",
        ),
      );
    }
  }
}
