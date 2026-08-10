import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../app/app_setup_locator.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../core/enums/bottom_sheet_type.dart';
import '../../../../../core/models/booking/booking_cost.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/models/ui/timeline_step.dart';
import '../../../../../core/services/bottom_sheet_service.dart';
import '../../../../../utils/helpers/socials_helper.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/back_arrow_button.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/buttons/sc_button.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../../../../widgets/driver_score_card.dart';
import '../../../../widgets/loaders/circular_indicator.dart';
import '../../../../widgets/trip_info_card.dart';
import '../../../../widgets/trip_route_map.dart';

import '../widgets/passengers_expandable_section.dart';
import '../widgets/route_stop_timeline_item.dart';
import '../widgets/vertical_time_line_item.dart';

class ApproveStatusWidget extends StatelessWidget {
  const ApproveStatusWidget({
    super.key,
    required this.summary,
    this.bookingCost,
    required this.isCostLoading,
    // this.onMessageTap,
  });

  final RideSummary summary;
  final BookingCost? bookingCost;
  final bool isCostLoading;
  // final VoidCallback? onMessageTap;

  // Cached constant colors to avoid allocation during frame rebuilds
  static const Color _warningBgColor = Color(0x1AF59F0A); // 10% opacity
  static const Color _warningBorderColor = Color(0xffF59F0A);
  static const Color _buttonBgColor = Color(0xffECF3FE);
  static const Color _primaryBlueColor = Color(0xff0846AA);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Map Header
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

                      Positioned(
                        top: 12,
                        left: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BackArrowButton(),

                            if (summary.isTripCompleted &&
                                summary.driver != null)
                              TextButton(
                                onPressed: () => sl<BottomSheetService>()
                                    .showCustomBottomSheet(
                                      variant: BottomSheetType.tripReview,
                                      data: {
                                        "tripId": summary.id,
                                        "driverId": summary.driver!.id,
                                      },
                                    ),
                                child: const Text("Review Trip"),
                              ),
                          ],
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
                                    value: bookingCost!
                                        .surgePercentageFormatted !=
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

                // Main Details Body
                Opacity(
                  opacity: summary.isTripCanceled ? 0.4 : 1.0,
                  child: AbsorbPointer(
                    absorbing: summary.isTripCanceled,
                    child: Column(
                      children: [
                        const SizedBox(height: 19),
                        PassengersExpandableSection(
                          passengers: summary.passengers ?? [],
                          passengerCount: summary.passengerSeats ?? 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: VerticalTimeline(
                            headerTitle: summary.friendlyHeaderStatus,
                            steps: TimelineStep.generateTimeline(
                              // Safe fallback to prevent NPEs
                              parentStatus: summary.status ?? '',
                              bookingStatus: summary.booking?.status,
                            ),
                          ),
                        ),

                        if (summary.driver != null && summary.vehicle != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DriverScoreCard(
                              driver: summary.driver!,
                              vehicle: summary.vehicle!,
                              tripId: summary.id,
                              showTruckCapacity: false,
                            ),
                          ),
                        DynamicRouteTimeline(summary: summary),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: AppDecoration.roundedOutlinedRadius16,
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: _warningBgColor,
                                    border: Border.all(color: _warningBorderColor),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgWidget(assetName: AppIcons.warning),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            text: "",
                                            children: [
                                              TextSpan(
                                                text:
                                                "Your Safety PIN is: ${summary.safetyPin} ",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const TextSpan(
                                                text:
                                                "Share this PIN with your driver to begin your trip.",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              ScButton(
                                bgColor: _buttonBgColor,
                                onClick: () => SocialHelper.sendEmail(
                                  "support@getryto.com",
                                ),
                                btnText: "Emergency Support",
                                btnTextStyle: const TextStyle(
                                  color: _primaryBlueColor,
                                ),
                              ),
                              const SizedBox(height: 17),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Action Bar
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Button.outline(
                  buttonColor: _buttonBgColor,
                  onTap: () async {
                    await sl<BottomSheetService>()
                    .showCustomBottomSheet(
                    variant: BottomSheetType.chat,
                    data: {
                    "tripId": summary.id,
                    'participantId': summary.driver?.id,
                    },
                    );
                  },
                  text: "Message",
                  textStyle: const TextStyle(color: _primaryBlueColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}