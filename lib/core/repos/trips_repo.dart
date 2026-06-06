import '../../app/app_setup_locator.dart';
import '../models/booking/booking_request.dart';
import '../models/booking/booking_response.dart';
import '../models/booking/booking_summary.dart';
import '../models/popular_route.dart';
import '../models/ride/ride_response.dart';
import '../services/api_service.dart';

abstract class TripsRepo {
  Future<RideResponse?> fetchAvailableTrips({
    int? passengerSeats,
    String? departureDate,
    String? destinationCity,
    String? originCity,
  });
  Future<List<PopularRoute>?> fetchPopularRoutes(String currency);
  Future<BookingSummary?> fetchBookingCost(BookingRequest request);
  Future<BookingResponse?> bookPackage(BookingRequest request);
  Future<BookingResponse?> scheduleTrip(BookingRequest request);
}

class TripsRepoImpl implements TripsRepo {
  final ApiService _service;

  TripsRepoImpl({ApiService? service}) : _service = service ?? sl<ApiService>();

  @override
  Future<RideResponse?> fetchAvailableTrips({
    int? passengerSeats,
    String? departureDate,
    String? destinationCity,
    String? originCity,
  }) async {
    final res = await _service.fetchAvailableTrips(
      passengerSeats: passengerSeats,
      departureDate: departureDate,
      destinationCity: destinationCity,
      originCity: originCity,
    );
    return res.data;
  }

  @override
  Future<List<PopularRoute>?> fetchPopularRoutes(String currency) async {
    final res = await _service.fetchPopularRoutes(currency);
    return res.data;
  }

  @override
  Future<BookingSummary?> fetchBookingCost(BookingRequest request) async {
    final res = await _service.fetchBookingCost(request);
    return res.data;
  }

  @override
  Future<BookingResponse?> bookPackage(BookingRequest request) async {
    final res = await _service.bookPackage(request);
    return res.data;
  }

  @override
  Future<BookingResponse?> scheduleTrip(BookingRequest request) async {
    final res = await _service.scheduleTrip(request);
    return res.data;
  }
}
