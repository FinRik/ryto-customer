import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../app/app_setup_locator.dart';
import '../../../../../core/enums/bottom_sheet_type.dart';
import '../../../../../core/models/booking/booking_cost.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/services/bottom_sheet_service.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/back_arrow_button.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../../../../widgets/loaders/circular_indicator.dart';
import '../../../../widgets/trip_info_card.dart';
import '../../../../widgets/trip_route_map.dart';
import '../widgets/policy_info_box.dart';
import '../widgets/trip_detail_card.dart';

class CanceledStatusWidget extends StatelessWidget {
  const CanceledStatusWidget({
    super.key,
    required this.summary,
    this.bookingCost,
    required this.isCostLoading,
  });

  final RideSummary summary;
  final BookingCost? bookingCost;
  final bool isCostLoading;

  // Cached static color constants to eliminate GC frame drops on rebuilds
  static const Color _cardBorderColor = Color(0xFFE0E5F2);
  static const Color _darkTextColor = Color(0xFF1B2559);
  static const Color _reasonTextColor = Color(0xff696E7E);

  @override
  Widget build(BuildContext context) {
    final String passengerLabel =
        "${summary.passengerSeats ?? 0} Passenger${(summary.passengerSeats ?? 0) > 1 ? 's' : ''}";
    final String departureLabel = summary.departureTime;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (isCostLoading) Center(child: CircularIndicator()),
          SizedBox(
            height: 280,
            child: Stack(
              children: [
                Container(
                  height: 225,
                  width: double.infinity,
                  color: Colors.green.shade100,
                  child: TripRouteMap(
                    olat: summary.originLat,
                    olng: summary.originLng,
                    dlat: summary.destinationLat,
                    dlng: summary.destinationLng,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("trip_route"),
                        color: Colors.blue,
                        width: 5,
                        points: [
                          LatLng(summary.originLat, summary.originLng),
                          LatLng(summary.pickupLat, summary.pickupLng),
                          LatLng(summary.dropoffLat, summary.dropoffLng),
                          LatLng(
                            summary.destinationLat,
                            summary.destinationLng,
                          ),
                        ],
                      ),
                    },
                  ),
                ),

                const Positioned(
                  top: 12,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [BackArrowButton()],
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      isCostLoading && bookingCost == null
                          ? CircularIndicator()
                          : TripInfoCard(
                              tripInfos: [
                                TripInfo(
                                  title: "Departure",
                                  value: summary.departureTime,
                                ),
                                if (bookingCost != null)
                                  TripInfo(
                                    title: "Price",
                                    value:
                                        bookingCost!.surgePercentageFormatted !=
                                            null
                                        ? "${bookingCost?.finalPrice?.formatted}"
                                        : "${bookingCost?.totalPrice?.formatted}",
                                    isAmount: true,
                                    alignment: Alignment.center,
                                  ),
                                TripInfo(
                                  title: "Seats",
                                  value: "${summary.passengerSeats ?? 0}",
                                  alignment: Alignment.centerRight,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // const StatusIndicatorHeader(statusText: "Trip Canceled", showIcon: false,),
                if (summary.isBookingCanceled) ...[
                  Container(
                    width: double.infinity,
                    decoration: AppDecoration.roundedOutlinedRadius16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Reason for Cancellation",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _darkTextColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          summary.friendlyHeaderStatus,
                          style: const TextStyle(
                            fontSize: 14,
                            color: _reasonTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),

                if (!isCostLoading) ...[
                  TripDetailCard(
                    fare: bookingCost?.surgePercentageFormatted != null
                        ? "${bookingCost?.finalPrice?.formatted}"
                        : "${bookingCost?.totalPrice?.formatted}",
                    pickup: summary.pickupCoord,
                    dropOff: summary.dropOffCoord,
                    originAddress: summary.originCity,
                    destinationAddress: summary.destinationCity,
                    date: departureLabel,
                    passengers: passengerLabel,
                    serviceTier: summary.vehicle?.serviceTier ?? "PREMIER",
                  ),
                  const SizedBox(height: 24),

                  // Concrete refund notification layout
                  CurrencyFormatterWidget(
                    amount: bookingCost?.surgePercentageFormatted != null
                        ? "${bookingCost?.finalPrice?.formatted}"
                        : "${bookingCost?.totalPrice?.formatted}",
                    builder: (ctx, value, rawAmount) => PolicyInfoBox(
                      title: "Refund Status Initiated",
                      description:
                          "This booking request was canceled. A total refund of $value has been processed and returned to your original payment method. Please allow a few business days for it to reflect.",
                      icon: Icons.assignment_return_outlined,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => sl<BottomSheetService>().showCustomBottomSheet(
                        variant: BottomSheetType.contactSupport,
                      ),
                      icon: const Icon(Icons.headset_mic_outlined),
                      label: const Text("Contact Support For Inquiries"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: _cardBorderColor),
                        foregroundColor: _darkTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
