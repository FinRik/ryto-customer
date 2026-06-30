import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../core/models/booking/booking_cost.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../utils/helpers/socials_helper.dart';
import '../../../../bottom_sheets/cancel_bottom_sheet.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/back_arrow_button.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../../../../widgets/loaders/circular_indicator.dart';
import '../bloc/bookings_bloc.dart';
import '../widgets/policy_info_box.dart';
import '../widgets/trip_detail_card.dart';

class PendingStatusWidget extends StatelessWidget {
  const PendingStatusWidget({
    super.key,
    required this.summary,
    this.bookingCost,
    required this.isCostLoading,
    required this.isActionLoading,
  });

  final RideSummary summary;
  final BookingCost? bookingCost;
  final bool isCostLoading;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final String passengerLabel =
        "${summary.passengerSeats ?? 0} Passenger${(summary.passengerSeats ?? 0) > 1 ? 's' : ''}";
    final String departureLabel = summary.departureTime;

    final showGlobalSpinner = (bookingCost == null && isCostLoading) || isActionLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackArrowButton(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            StatusIndicatorHeader(
              statusText: (summary.friendlyHeaderStatus),
            ),
            const SizedBox(height: 32),

            if (showGlobalSpinner)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularIndicator()),
              ),

            if (!isCostLoading && !isActionLoading) ...[
              TripDetailCard(
                fare:  bookingCost?.surgePercentageFormatted != null
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

              CurrencyFormatterWidget(
                amount: bookingCost?.surgePercentageFormatted != null ?"${bookingCost?.finalPrice?.formatted}": "${bookingCost?.totalPrice?.formatted}",
                builder: (ctx, value, rawAmount) => PolicyInfoBox(
                  title: "Auto-Refund Policy",
                  description:
                  "Total peace of mind. If the driver does not accept your request within the window, a full refund of $value will be instantly initiated to your original payment method.",
                  icon: Icons.verified_user_outlined,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration:
                AppDecoration.roundedOutlinedRadius16,
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: AppDecoration
                      .roundedOutlinedRadius16
                      .copyWith(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(
                      0xffF59F0A,
                    ).withOpacity(.10),
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      SvgWidget(assetName: AppIcons.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "Your Safety PIN is ",
                            children: [
                              TextSpan(
                                text: "${summary.safetyPin} ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                "Share with driver when boarding.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => SocialHelper.sendEmail("support@getryto.com"),
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

              if (!summary.isTripCanceled)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextButton(
                    onPressed: () async {
                      // Hand context reference down safely
                      final bookingsBloc = context.read<BookingsBloc>();
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => CancelBookingBottomSheet(
                          bookingId: "${summary.booking?.id}",
                          bookingsBloc: bookingsBloc,
                        ),
                      );
                    },
                    child: const Text(
                      "Cancel Request",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
