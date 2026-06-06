import 'package:flutter/material.dart';

import '../../../../../app/app_setup_locator.dart';
import '../../../../../core/models/booking/booking_request.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/setups/region_identity_setup.dart';
import '../../../../widgets/booking_cost_selector.dart';
import '../../../../widgets/buttons/back_arrow_button.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../widgets/policy_info_box.dart';
import '../widgets/trip_detail_card.dart';

class PendingStatusWidget extends StatelessWidget {
  const PendingStatusWidget({super.key, required this.summary});

  final RideSummary summary;

  @override
  Widget build(BuildContext context) {
    final region = sl<RegionIdentity>();
    // Formatting values for the UI
    final String passengerLabel =
        "${summary.passengerSeats ?? 0} Passenger${(summary.passengerSeats ?? 0) > 1 ? 's' : ''}";
    final String departureLabel = summary.departureTime ?? "TBA";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackArrowButton(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Row(
              children: [
                Icon(Icons.share_outlined, color: Color(0xFF1B2559)),
                SizedBox(width: 8),
                Text("Share", style: TextStyle(color: Color(0xFF1B2559))),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // 1. Status based on trip.status
            StatusIndicatorHeader(
              statusText: _mapStatusToMessage(summary.status),
            ),
            const SizedBox(height: 32),

            // 2. Dynamic Trip Detail Card
            BookingCostSelector(
              request: BookingRequest(
                vehicleId: summary.vehicle?.id,
                tripId: summary.id,
                seats: summary.passengerSeats,
                pickupLocation: summary.pickupCoord,
                dropoffLocation: summary.dropOffCoord,
                originLocation: summary.originCoord,
                destinationLocation: summary.destCoord,
                bookingLocation: region.country,
              ),
              builder: (context, response) => TripDetailCard(
                fare: "${response.seatPrice?.formatted}",
                pickup: summary.pickupCoord,
                // LatLng(
                //   lat: summary.pickupLat ?? summary.originLat ?? 0.0,
                //   lng: summary.pickupLng ?? summary.originLng ?? 0.0,
                // ),
                dropOff: summary.dropOffCoord,
                // LatLng(
                //   lat: summary.dropoffLat ?? summary.destinationLat ?? 0.0,
                //   lng: summary.dropoffLng ?? summary.destinationLng ?? 0.0,
                // ),
                originAddress: summary.originCity ?? "Unknown Origin",
                destinationAddress:
                    summary.destinationCity ?? "Unknown Destination",
                date: departureLabel,
                passengers: passengerLabel,
                // isPremium: (response.seatPrice ?? 0) > 5000,
                isPremium: summary.vehicle?.serviceTier == "PREMIUM",
              ),
            ),
            const SizedBox(height: 24),

            BookingCostSelector(
              request: BookingRequest(
                vehicleId: summary.vehicle?.id,
                tripId: summary.id,
                seats: summary.passengerSeats,
                pickupLocation: summary.pickupCoord,
                dropoffLocation: summary.dropOffCoord,
                originLocation: summary.originCoord,
                destinationLocation: summary.destCoord,
                bookingLocation: region.country,
              ),
              builder: (context, response) => CurrencyFormatterWidget(
                amount: "${response.seatPrice?.formatted}",
                builder: (ctx, value, rawAmount) => PolicyInfoBox(
                  title: "Auto-Refund Policy",
                  description:
                      "Total peace of mind. If the driver does not accept your request within the window, a full refund of $value will be instantly initiated to your original payment method.",
                  icon: Icons.verified_user_outlined,
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.headset_mic_outlined),
                label: const Text("Contact Support"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFE0E5F2)),
                  foregroundColor: const Color(0xFF1B2559),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Cancel Request",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to make status readable
  String _mapStatusToMessage(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return "Awaiting Driver Acceptance";
      case 'accepted':
        return "Driver is on the way";
      case 'cancelled':
        return "Booking Cancelled";
      default:
        return "Processing your Request";
    }
  }
}
