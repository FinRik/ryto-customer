import 'package:flutter/material.dart';
import '../core/models/lat_lng.dart';
import '../core/models/ride/ride_summary.dart';
import '../core/models/ui/route_stop_timeline.dart';
import 'helpers/location_utils.dart';


class RouteTimelineMapper {
  static Future<List<RouteStopTimeline>> buildSecureTimelineSteps(RideSummary ride) async {
    List<RouteStopTimeline> steps = [];

    // Find the current user's personal booking object from the passenger list
    final currentUserBooking = ride.passengers?.firstWhere(
          (p) => p.id == ride.booking?.id,
      // orElse: () => ,
    );

    if (currentUserBooking == null) return steps;

    // --- 1. CURRENT USER'S PICKUP ---
    final LatLng? myPickupAddress = await LocationUtils.getAddressFromCoordinate(
        LatLng(
            lat: currentUserBooking.passengerPickupLat ?? 0.0,
            lng: currentUserBooking.passengerPickupLng ?? 0.0
        )
    );

    steps.add(
      RouteStopTimeline(
        title: "Your Pickup",
        subtitle: myPickupAddress!.address!,
        indicatorColor: Colors.green,
        latitude: currentUserBooking.passengerPickupLat ?? 0.0,
        longitude: currentUserBooking.passengerPickupLng ?? 0.0,
      ),
    );

    // --- 2. INTERMEDIATE CO-PASSENGER STOPS ("Short Stops") ---
    if (ride.passengers != null) {
      // Collect geocoding tasks to resolve them concurrently rather than sequentially in a loop
      List<Future<void>> geocodingTasks = [];

      for (var passenger in ride.passengers!) {
        // Secure Privacy Shield: Completely skip the current user's profile info here
        if (passenger.id == ride.booking?.id) continue;

        // Safe Check: Handle intermediate pickup point
        if (passenger.passengerPickupLat != null && passenger.passengerPickupLng != null) {
          geocodingTasks.add(
            LocationUtils.getAddressFromCoordinate(
                LatLng(lat: passenger.passengerPickupLat!, lng: passenger.passengerPickupLng!)
            ).then((resolvedAddress) {
              steps.add(
                RouteStopTimeline(
                  title: 'Short Stop',
                  // Keep descriptions generalized to shield target user personal identifiers
                  subtitle: resolvedAddress?.address ?? 'Passenger pickup location',
                  indicatorColor: Colors.amber,
                  latitude: passenger.passengerPickupLat!,
                  longitude: passenger.passengerPickupLng!,
                ),
              );
            }),
          );
        }

        // Safe Check: Handle intermediate drop-off point
        if (passenger.passengerDropoffLat != null && passenger.passengerDropoffLng != null) {
          geocodingTasks.add(
            LocationUtils.getAddressFromCoordinate(
                LatLng(lat: passenger.passengerDropoffLat!, lng: passenger.passengerDropoffLng!)
            ).then((resolvedAddress) {
              steps.add(
                RouteStopTimeline(
                  title: 'Short Stop',
                  subtitle: resolvedAddress?.address ?? 'Passenger drop-off location',
                  indicatorColor: Colors.amber,
                  latitude: passenger.passengerDropoffLat!,
                  longitude: passenger.passengerDropoffLng!,
                ),
              );
            }),
          );
        }
      }

      // Await all background address translation lookups simultaneously
      if (geocodingTasks.isNotEmpty) {
        await Future.wait(geocodingTasks);
      }
    }

    // --- 3. CURRENT USER'S DROP-OFF ---
    final LatLng? myDropoffAddress = await LocationUtils.getAddressFromCoordinate(
        LatLng(
            lat: currentUserBooking.passengerDropoffLat ?? 0.0,
            lng: currentUserBooking.passengerDropoffLng ?? 0.0
        )
    );

    steps.add(
      RouteStopTimeline(
        title: "Your Drop-off",
        subtitle: myDropoffAddress?.address ?? "",
        indicatorColor: Colors.red,
        latitude: currentUserBooking.passengerDropoffLat ?? 0.0,
        longitude: currentUserBooking.passengerDropoffLng ?? 0.0,
      ),
    );

    return steps;
  }


  /// Converts raw backend trip response data into fully geocoded UI timeline steps.
  static Future<List<RouteStopTimeline>> buildTimelineFromCoordinates({
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
  }) async {

    // 1. Fire off reverse geocoding lookups concurrently
    final addressResults = await Future.wait([
      LocationUtils.getAddressFromCoordinate(LatLng(lat: pickupLat, lng: pickupLng)),
      LocationUtils.getAddressFromCoordinate(LatLng(lat: dropoffLat, lng: dropoffLng)),
    ]);

    // 2. Fall back cleanly to standard coordinate text strings if geocoding returns null
    final String resolvedPickup = "${addressResults[0] ?? "$pickupLat, $pickupLng"}";
    final String resolvedDropoff = "${addressResults[1] ?? "$dropoffLat, $dropoffLng"}";

    // 3. Construct ready-to-render data objects directly for the UI
    return [
      RouteStopTimeline(
        title: "Your Pickup",
        subtitle: resolvedPickup,
        indicatorColor: Colors.green,
        latitude: pickupLat,
        longitude: pickupLng,
        isFilled: true,
      ),
      RouteStopTimeline(
        title: "Your Drop-off",
        subtitle: resolvedDropoff,
        indicatorColor: Colors.red,
        latitude: dropoffLat,
        longitude: dropoffLng,
        isFilled: true,
      ),
    ];
  }
}