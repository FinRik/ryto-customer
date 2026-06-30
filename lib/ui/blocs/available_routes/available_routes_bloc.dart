import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/ride/ride.dart';
import '../../../../core/models/booking/booking_cost.dart';
import '../../../../core/repos/trips_repo.dart';
import '../../../core/models/booking/booking_request.dart';
import '../../../core/models/lat_lng.dart';
import '../../../core/models/popular_route.dart';

part 'available_routes_event.dart';
part 'available_routes_state.dart';

class AvailableTripsBloc
    extends Bloc<AvailableTripsEvent, AvailableTripsState> {
  final TripsRepo repo;

  AvailableTripsBloc({required this.repo})
    : super(const AvailableTripsState()) {
    on<FetchTripsAndCosts>(_onFetchTripsAndCosts);
    on<FetchPopularRoutes>(_onFetchPopularRoutes);
  }

  Future<void> _onFetchTripsAndCosts(
    FetchTripsAndCosts event,
    Emitter<AvailableTripsState> emit,
  ) async {
    emit(state.copyWith(status: TripsSearchStatus.loading));
    try {
      final res = await repo.fetchAvailableTrips(
        passengerSeats: event.searchParams['passengerSeats'],
        departureDate: event.searchParams['departureDate'],
        destinationCity: event.searchParams['destinationCity'],
        originCity: event.searchParams['originCity'],
        country: event.searchParams['country'],
        currency: event.searchParams['currency'],
      );

      final tripsList = res?.data ?? [];
      emit(state.copyWith(status: TripsSearchStatus.success, trips: tripsList));

      // Resolve costs asynchronously in parallel batches safely behind the scenes
      final Map<int, BookingCost> resolvedCosts = Map.from(state.tripCosts);

      final costFutures = tripsList.map((trip) async {
        try {
          final cost = await repo.fetchBookingCost(
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

          if (cost != null && trip.id != null) {
            resolvedCosts[trip.id] = cost;
          }
        } catch (e) {
          log("Failed to resolve cost for trip ID ${trip.id}: $e");
        }
      });

      await Future.wait(costFutures);
      emit(state.copyWith(tripCosts: resolvedCosts));
    } catch (e) {
      emit(
        state.copyWith(
          status: TripsSearchStatus.failure,
          errorMessage: "Unable to load trips at the moment.",
        ),
      );
    }
  }

  Future<void> _onFetchPopularRoutes(
      FetchPopularRoutes event,
      Emitter<AvailableTripsState> emit,
      ) async {
    // 1. Mark only the routes sub-state as loading
    emit(state.copyWith(routesStatus: PopularRoutesStatus.loading, errorMessage: null));

    try {
      final res = await repo.fetchPopularRoutes(event.currency);

      emit(
        state.copyWith(
          routesStatus: PopularRoutesStatus.success,
          routes: res ?? [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          routesStatus: PopularRoutesStatus.failure,
          errorMessage: "Failed to fetch popular routes. Please try again later.",
        ),
      );
    }
  }
}