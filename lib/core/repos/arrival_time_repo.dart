import '../models/arrival_estimate.dart';
import '../services/arrival_time_service.dart';

abstract class ArrivalTimeRepo {
  Future<ArrivalEstimate> getArrivalData({
    required double sLat,
    required double sLng,
    required double eLat,
    required double eLng,
    DateTime? departureDate,
    String? departureTime,
  });
}

class ArrivalTimeRepoImpl implements ArrivalTimeRepo {
  final ArrivalTimeService _service;

  ArrivalTimeRepoImpl(ArrivalTimeService service) : _service = service;

  @override
  Future<ArrivalEstimate> getArrivalData({
    required double sLat,
    required double sLng,
    required double eLat,
    required double eLng,
    DateTime? departureDate,
    String? departureTime,
  }) async {
    // 1. Start with the provided date or fall back to today
    DateTime baseDate = departureDate ?? DateTime.now();
    DateTime finalStart = baseDate;

    // 2. Overwrite the time portion if a string like "08:00" is provided
    if (departureTime != null && departureTime.contains(':')) {
      try {
        final parts = departureTime.split(':');
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);

        finalStart = DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          hours,
          minutes,
        );
      } catch (e) {
        print("Time parsing failed, using base date: $e");
      }
    }

    // 3. Call the service with the accurate merged start time
    return await _service.fetchEstimate(
      sLat: sLat,
      sLng: sLng,
      eLat: eLat,
      eLng: eLng,
      startTime: finalStart,
    );
  }
}
