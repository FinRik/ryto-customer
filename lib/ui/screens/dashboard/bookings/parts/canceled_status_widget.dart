import 'package:flutter/material.dart';

import '../../../../../core/models/booking/booking_cost.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../utils/helpers/socials_helper.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/back_arrow_button.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../../../../widgets/loaders/circular_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    final String passengerLabel =
        "${summary.passengerSeats ?? 0} Passenger${(summary.passengerSeats ?? 0) > 1 ? 's' : ''}";
    final String departureLabel = summary.departureTime;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        router.go(Paths.HOME);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BackArrowButton(onPressed: () => router.pop()),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              StatusIndicatorHeader(statusText: "Trip Canceled"),
              const SizedBox(height: 32),

              if (isCostLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularIndicator()),
                ),

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

                // Shifted from refund policy to concrete refund notification layout
                CurrencyFormatterWidget(
                  amount: "${bookingCost?.seatPrice?.formatted}",
                  builder: (ctx, value, rawAmount) => PolicyInfoBox(
                    title: "Refund Status Initiated",
                    description:
                        "This booking request was canceled. A total refund of $value has been processed and returned to your original payment method. Please allow a few business days for it to reflect.",
                    icon: Icons.assignment_return_outlined,
                    // iconColor: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 32),

                // Clean Info Box noting the cancellation reasoning if available
                if (summary.isBookingCanceled) ...[
                  Container(
                    width: double.infinity,
                    decoration: AppDecoration.roundedOutlinedRadius16,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Reason for Cancellation",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2559),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          summary.friendlyHeaderStatus,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff696E7E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        SocialHelper.sendEmail("support@getryto.com"),
                    icon: const Icon(Icons.headset_mic_outlined),
                    label: const Text("Contact Support For Inquiries"),
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
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
