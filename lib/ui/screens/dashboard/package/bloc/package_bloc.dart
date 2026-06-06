import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/booking/booking_request.dart';
import '../../../../../core/models/booking/booking_response.dart';
import '../../../../../core/models/booking/booking_summary.dart';
import '../../../../../core/models/meta.dart';
import '../../../../../core/models/popular_route.dart';
import '../../../../../core/models/ride/ride.dart';
import '../../../../../core/repos/trips_repo.dart';

part 'package_event.dart';
part 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final TripsRepo repo;

  PackageBloc(this.repo) : super(PackageState(request: BookingRequest())) {
    on<UpdatePackageProgress>(_onUpdateProgress);
    on<FetchRoutesRequested>(_onFetchPopularRoutes);
    on<FetchAvailablePackageRequested>(_onFetchAvailableTrips);
    on<FetchBookingCostRequested>(_onFetchCost);
    on<BookPackageRequested>(_onScheduleTrip);
  }

  void _onUpdateProgress(
    UpdatePackageProgress event,
    Emitter<PackageState> emit,
  ) {
    final updatedRequest = _merge(state.request, event.partialRequest);
    emit(state.copyWith(request: updatedRequest));
  }

  Future<void> _onFetchPopularRoutes(
    FetchRoutesRequested event,
    Emitter<PackageState> emit,
  ) async {
    emit(state.copyWith(routesStatus: PopularRoutesStatus.loading));
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
          errorMessage: "Failed to fetch routes",
        ),
      );
    }
  }

  Future<void> _onFetchAvailableTrips(
    FetchAvailablePackageRequested event,
    Emitter<PackageState> emit,
  ) async {
    emit(state.copyWith(tripsStatus: AvailableTripsStatus.loading));
    try {
      final res = await repo.fetchAvailableTrips(
        passengerSeats: event.passengerSeats,
        departureDate: event.departureDate,
        destinationCity: event.destinationCity,
        originCity: event.originCity,
      );
      emit(
        state.copyWith(
          tripsStatus: AvailableTripsStatus.success,
          availableTrips: res?.data ?? [],
          tripsMeta: res?.meta,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          tripsStatus: AvailableTripsStatus.failure,
          errorMessage: "Failed to available routes",
        ),
      );
    }
  }

  Future<void> _onFetchCost(
    FetchBookingCostRequested event,
    Emitter<PackageState> emit,
  ) async {
    emit(state.copyWith(setupStatus: PackageBookingStatus.loading));
    try {
      final res = await repo.fetchBookingCost(state.request);
      if (res != null) {
        emit(
          state.copyWith(
            setupStatus: PackageBookingStatus.success,
            costSummary: res,
          ),
        );
      } else {
        emit(
          state.copyWith(
            setupStatus: PackageBookingStatus.failure,
            errorMessage: "Failed to calculate trip cost",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          setupStatus: PackageBookingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onScheduleTrip(
    BookPackageRequested event,
    Emitter<PackageState> emit,
  ) async {
    emit(state.copyWith(setupStatus: PackageBookingStatus.loading));
    try {
      final res = await repo.scheduleTrip(state.request);
      if (res != null) {
        emit(
          state.copyWith(
            setupStatus: PackageBookingStatus.success,
            scheduleResponse: res,
          ),
        );
      } else {
        emit(
          state.copyWith(
            setupStatus: PackageBookingStatus.failure,
            errorMessage: "Failed to schedule trip",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          setupStatus: PackageBookingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  BookingRequest _merge(BookingRequest current, BookingRequest incoming) {
    return current.copyWith(
      tripId: incoming.tripId ?? current.tripId,
      bookingLocation: incoming.bookingLocation ?? current.bookingLocation,
      vehicleId: incoming.vehicleId ?? current.vehicleId,
      seats: incoming.seats ?? current.seats,
      packageRecipientName: incoming.packageRecipientName ?? current.packageRecipientName,
      packageRecipientPhone: incoming.packageRecipientPhone ?? current.packageRecipientPhone,
      packageSize: incoming.packageSize ?? current.packageSize,
      packageWeight: incoming.packageWeight ?? current.packageWeight,
      packageHandlingOptions:
          incoming.packageHandlingOptions ?? current.packageHandlingOptions,
      packageContent: incoming.packageContent ?? current.packageContent,
      originLocation: incoming.originLocation ?? current.originLocation,
      pickupLocation: incoming.pickupLocation ?? current.pickupLocation,
      dropoffLocation: incoming.dropoffLocation ?? current.dropoffLocation,
      destinationLocation:
          incoming.destinationLocation ?? current.destinationLocation,
    );
  }
}