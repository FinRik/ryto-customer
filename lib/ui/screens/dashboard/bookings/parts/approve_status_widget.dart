import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../app/app_setup_locator.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../core/enums/bottom_sheet_type.dart';
import '../../../../../core/models/booking/booking_request.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/models/ui/route_stop_timeline.dart';
import '../../../../../core/models/ui/timeline_step.dart';
import '../../../../../core/services/bottom_sheet_service.dart';
import '../../../../../core/setups/region_identity_setup.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/booking_cost_selector.dart';
import '../../../../widgets/buttons/back_arrow_button.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/buttons/sc_button.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../../../../widgets/driver_score_card.dart';
import '../../../../widgets/trip_info_card.dart';
import '../../../../widgets/trip_route_map.dart';

import '../widgets/passengers_expandable_section.dart';
import '../widgets/route_stop_timeline_item.dart';
import '../widgets/vertical_time_line_item.dart';

class ApproveStatusWidget extends StatelessWidget {
  const ApproveStatusWidget({super.key, required this.summary});

  final RideSummary summary;

  @override
  Widget build(BuildContext context) {
    final String displayTime = summary.departureTime ?? "--:--";
    final region = sl<RegionIdentity>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 280,
              child: Stack(
                children: [
                  Container(
                    height: 225,
                    width: double.infinity,
                    color: Colors.green.shade100,
                    child: TripRouteMap(
                      olat: summary.originLat ?? 0.0,
                      olng: summary.originLng ?? 0.0,
                      dlat: summary.destinationLat ?? 0.0,
                      dlng: summary.destinationLng ?? 0.0,
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId("pickup_route"),
                          color: Colors.blue,
                          width: 5,
                          points: [
                            LatLng(
                              summary.pickupLat ?? 0.0,
                              summary.pickupLng ?? 0.0,
                            ),
                            LatLng(
                              summary.dropoffLat ?? 0.0,
                              summary.dropoffLng ?? 0.0,
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
                        const BackArrowButton(),
                        IconButton(
                          onPressed: () {
                            // Share trip details logic
                          },
                          icon: const Row(
                            children: [
                              Icon(
                                Icons.share_outlined,
                                color: Color(0xFF1B2559),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Share",
                                style: TextStyle(color: Color(0xFF1B2559)),
                              ),
                            ],
                          ),
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
                          builder: (context, response) => TripInfoCard(
                            tripInfos: [
                              TripInfo(title: "Departure", value: displayTime),
                              TripInfo(
                                title: "Price",
                                value: "${response.seatPrice?.formatted}",
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 19),
                    // Using null-safety and list defaults
                    PassengersExpandableSection(
                      passengers: summary.passengers ?? [],
                      passengerCount: summary.passengerSeats ?? 0,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: VerticalTimeline(
                        headerTitle: _getFriendlyHeaderStatus(summary.status),
                        steps: TimelineStep.generateTimeline(summary.status),
                      ),
                    ),

                    if (summary.driver != null && summary.vehicle != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DriverScoreCard(
                          driver: summary.driver!,
                          vehicle: summary.vehicle!,
                          tripId: summary.id,
                          showTruckCapacity: summary.packagesAllowed ?? false,
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RouteStopTimelineWidget(
                        headerTitle: 'Route',
                        steps: RouteStopTimeline.routeSteps,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: AppDecoration.roundedOutlinedRadius16,
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: AppDecoration.roundedOutlinedRadius16
                                  .copyWith(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(
                                      0xffF59F0A,
                                    ).withOpacity(.10),
                                  ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(height: 22),
                          ScButton(
                            bgColor: const Color(0xffECF3FE),
                            onClick: () {},
                            btnText: "Emergency Support",
                            btnTextStyle: const TextStyle(
                              color: Color(0xff0846AA),
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
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Button.outline(
                buttonColor: const Color(0xffECF3FE),
                onTap: () async =>
                    await sl<BottomSheetService>().showCustomBottomSheet(
                      variant: BottomSheetType.chat,
                      data: {
                        "tripId": summary.id,
                        'participantId': summary.driver?.id,
                      },
                    ),
                text: "Message",
                textStyle: const TextStyle(color: Color(0xff0846AA)),
              ),
            ),
            const SizedBox(width: 8),
            // Expanded(
            //   flex: 1,
            //   child: Button(
            //     buttonColor: const Color(0xffECF3FE),
            //     onTap: () async => await CallServiceUtil.makePhoneCall(
            //       "${summary.driver!.phone}",
            //     ),
            //     text: "Call",
            //     textStyle: const TextStyle(color: Color(0xff0846AA)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

String _getFriendlyHeaderStatus(String? rawStatus) {
  switch (rawStatus?.toUpperCase()) {
    case "PENDING":
    case "SCHEDULED":
      return "Trip Scheduled";
    case "BOOKED":
      return "Trip Booked";
    case "DRIVER_ACCEPTED":
      return "Driver is Assigned";
    case "DRIVER_REJECTED":
      return "Driver Canceled";
    case "TRIP_STARTED":
      return "Trip En Route";
    case "TRIP_COMPLETED":
      return "Arrived Safely";
    default:
      return "Finding your Trip";
  }
}
