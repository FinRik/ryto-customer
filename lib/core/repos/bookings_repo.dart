import '../../app/app_setup_locator.dart';
import '../models/ride/ride_response.dart';
import '../models/ride/ride_summary.dart';
import '../services/api_service.dart';

abstract class BookingsRepo {
  Future<RideResponse?> fetchUserTrips(String status);
  Future<RideSummary?> fetchTripSummary(String id);
}

class BookingsRepoImpl implements BookingsRepo {
  final ApiService _service;

  BookingsRepoImpl({ApiService? service})
    : _service = service ?? sl<ApiService>();

  @override
  Future<RideResponse?> fetchUserTrips(String status) async {
    final result = await _service.fetchUserTrips(status);
    return result.data;
  }

  @override
  Future<RideSummary?> fetchTripSummary(String id) async {
    final result = await _service.fetchTripSummary(id);
    return result.data;
  }
}
