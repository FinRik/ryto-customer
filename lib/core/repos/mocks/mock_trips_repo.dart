import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/booking/booking_response.dart';
import '../../../../core/models/booking/booking_cost.dart';
import '../../../../core/models/popular_route.dart';
import '../../../../core/models/ride/ride_response.dart';
import '../../../../core/repos/trips_repo.dart';

class MockTripsRepo implements TripsRepo {
  final bool simulateVerificationFailure;

  MockTripsRepo({this.simulateVerificationFailure = false});

  @override
  Future<BookingCost?> fetchBookingCost(BookingRequest request) async {
    return BookingCost(
      totalPrice: PriceDetail(formatted: "₦15,000", raw: 15000),
      finalPrice: PriceDetail(formatted: "₦15,000", raw: 15000),
      surgePercentageFormatted: null,
    );
  }

  @override
  Future<BookingResponse?> scheduleTrip(BookingRequest request) async {
    // Simulate swift backend database scheduling
    await Future.delayed(const Duration(milliseconds: 500));
    return BookingResponse(bookingId: "98765", transactionId: 12345);
  }

  @override
  Future<bool> verifyPayment({
    required int transactionId,
    required int bookingId,
    required String reference,
  }) async {
    // Crucial: Long artificial delay allows the UI to change screens first
    await Future.delayed(const Duration(seconds: 3));

    if (simulateVerificationFailure) {
      throw Exception("Simulated background network failure");
    }
    return true;
  }

  // --- Unused Interface Placeholders ---
  @override
  Future<RideResponse?> fetchAvailableTrips({
    int? passengerSeats,
    String? departureDate,
    String? destinationCity,
    String? originCity,
    required String currency,
    required String country,
  }) async => null;
  @override
  Future<List<PopularRoute>?> fetchPopularRoutes(String currency) async => null;
  @override
  Future<BookingResponse?> bookPackage(BookingRequest request) async => null;
  @override
  Future<bool> cancelTrip({
    required String reason,
    required int bookingId,
  }) async => true;
}
