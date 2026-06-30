import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/models/booking/booking_request.dart';
import '../../../../../core/models/booking/booking_cost.dart';
import '../../../../../core/models/lat_lng.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/repos/bookings_repo.dart';
import '../../../../../core/models/ride/ride.dart';
import '../../../../../core/repos/trips_repo.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final BookingsRepo repo;
  final TripsRepo tripsRepo;

  BookingsBloc({required this.repo, required this.tripsRepo})
    : super(const BookingsState()) {
    on<LoadUserTrips>(_onLoadTrips);
    on<LoadTripSummary>(_onLoadTripSummary);
    on<LoadBookingCost>(_onLoadBookingCost);
    on<CancelBooking>(_onCancelBooking);
  }

  // Future<void> _onLoadTrips(
  //   LoadUserTrips event,
  //   Emitter<BookingsState> emit,
  // ) async {
  //   emit(state.copyWith(status: BookingsStatus.loading));
  //
  //   try {
  //     final trips = await repo.fetchUserTrips(event.status);
  //
  //     emit(
  //       state.copyWith(
  //         status: BookingsStatus.success,
  //         trips: trips?.data ?? [],
  //         errorMessage: () => null,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: BookingsStatus.failure,
  //         errorMessage: () => "Failed to load bookings, please try again later",
  //       ),
  //     );
  //   }
  // }

  Future<void> _onLoadTrips(
      LoadUserTrips event,
      Emitter<BookingsState> emit,
      ) async {
    emit(state.copyWith(status: BookingsStatus.loading));

    try {
      final tripsResponse = await repo.fetchUserTrips(event.status);
      final List<Ride> trips = tripsResponse?.data ?? [];

      trips.sort((a, b) {
        final timeA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final timeB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return timeB.compareTo(timeA);
      });

      emit(
        state.copyWith(
          status: BookingsStatus.success,
          trips: trips,
          errorMessage: null,
        )
      );

      final Map<int, BookingCost> loadedCosts = Map.from(state.tripCosts);

      // For SCHEDULED active trips, resolve pricing directly in parallel stream batch processing
      if (event.status == "SCHEDULED" && trips.isNotEmpty) {
        final List<Future<void>> costFutures = trips.map((trip) async {
          try {
            final cost = await tripsRepo.fetchBookingCost(
              BookingRequest(
                tripId: trip.id,
                vehicleId: trip.vehicle?.id,
                seats: 1,
                originLocation: LatLng(
                  lat: trip.originLat,
                  lng: trip.originLng,
                ),
                destinationLocation: LatLng(
                  lat: trip.destinationLat,
                  lng: trip.destinationLng,
                ),
                pickupLocation: LatLng(
                  lat: trip.pickupLat,
                  lng: trip.pickupLng,
                ),
                dropoffLocation: LatLng(
                  lat: trip.dropoffLat,
                  lng: trip.dropoffLng,
                ),
                bookingLocation: event.searchParams['country'],

                // Explicitly pass null or default placeholders for package details
                // since this is an initial ride search list preview.
                packageSize: null,
                packageContent: null,
                packageWeight: null,
                packageHandlingOptions: null,
              ),
            );
            if (cost != null) {
              loadedCosts[trip.id] = cost;
            }
          } catch (_) {
            // Silently suppress individual computation drops to keep page loading stable
          }
        }).toList();

        await Future.wait(costFutures);
      }

      emit(
        state.copyWith(
          tripCosts: loadedCosts,
          errorMessage: () => null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookingsStatus.failure,
          errorMessage: () => "Failed to load bookings",
        ),
      );
    }
  }

  Future<void> _onLoadTripSummary(
    LoadTripSummary event,
    Emitter<BookingsState> emit,
  ) async {
    final isNewTrip = state.tripSummary == null || state.tripSummary!.id.toString() != event.id;

    emit(
      state.copyWith(
        summaryStatus: isNewTrip
            ? SummaryStatus.loading
            : SummaryStatus.refreshing,
        errorMessage: () => null,
        // tripSummary: isNewTrip ? () => null : null,
        // bookingCost: isNewTrip ? () => null : null,
      ),
    );

    try {
      final summary = await repo.fetchTripSummary(event.id);
      emit(
        state.copyWith(
          summaryStatus: SummaryStatus.success,
          tripSummary: summary,
          errorMessage: () => null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          summaryStatus: SummaryStatus.failure,
          errorMessage: () => "Failed to load booking, please try again later",
        ),
      );
    }
  }

  Future<void> _onLoadBookingCost(
    LoadBookingCost event,
    Emitter<BookingsState> emit,
  ) async {
    emit(
      state.copyWith(costStatus: CostStatus.loading, errorMessage: null),
    );
    try {
      final cost = await tripsRepo.fetchBookingCost(event.request);
      emit(
        state.copyWith(
          bookingCost: cost,
          costStatus: CostStatus.success,
          errorMessage: () => null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          costStatus: CostStatus.failure,
          errorMessage: () => "Failed to load booking cost",
        ),
      );
    }
  }

  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<BookingsState> emit,
  ) async {
    emit(state.copyWith(status: BookingsStatus.loading));
    try {
      await tripsRepo.cancelTrip(
        reason: event.reason,
        bookingId: event.bookingId,
      );
      emit(state.copyWith(status: BookingsStatus.canceled, errorMessage: null));
    } catch (_) {
      emit(
        state.copyWith(
          status: BookingsStatus.failure,
          errorMessage: () => "Failed to cancel trip",
        ),
      );
    }
  }
}
