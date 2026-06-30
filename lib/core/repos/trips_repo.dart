import '../../app/app_setup_locator.dart';
import '../models/booking/booking_request.dart';
import '../models/booking/booking_response.dart';
import '../models/booking/booking_cost.dart';
import '../models/popular_route.dart';
import '../models/ride/ride_response.dart';
import '../services/api_service.dart';

abstract class TripsRepo {
  Future<RideResponse?> fetchAvailableTrips({
    int? passengerSeats,
    String? departureDate,
    String? destinationCity,
    String? originCity,
    required String currency,
    required String country,
  });
  Future<List<PopularRoute>?> fetchPopularRoutes(String currency);
  Future<BookingCost?> fetchBookingCost(BookingRequest request);
  Future<BookingResponse?> bookPackage(BookingRequest request);
  Future<BookingResponse?> scheduleTrip(BookingRequest request);
  Future<bool> verifyPayment({
    required int transactionId,
    required int bookingId,
    required String reference,
  });
  Future<bool> cancelTrip({required String reason, required int bookingId});
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
    required String currency,
    required String country,
  }) async {
    final res = await _service.fetchAvailableTrips(
      passengerSeats: passengerSeats,
      departureDate: departureDate,
      destinationCity: destinationCity,
      originCity: originCity,
      country: country,
      currency: currency,
    );
    return res.data;
  }

  @override
  Future<List<PopularRoute>?> fetchPopularRoutes(String currency) async {
    final res = await _service.fetchPopularRoutes(currency);
    return res.data;
  }

  @override
  Future<BookingCost?> fetchBookingCost(BookingRequest request) async {
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

  @override
  Future<bool> verifyPayment({
    required int transactionId,
    required int bookingId,
    required String reference,
  }) async {
    final res = await _service.verifyPayment(
      transactionId,
      bookingId,
      reference,
    );
    return res.data;
  }

  @override
  Future<bool> cancelTrip({
    required String reason,
    required int bookingId,
  }) async {
    final res = await _service.cancelTrip(reason, bookingId);
    return res.code == 200;
  }
}
