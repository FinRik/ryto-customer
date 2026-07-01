import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../app/app_setup_locator.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../core/enums/bottom_sheet_type.dart';
import '../../../../../core/models/booking/booking_cost.dart';
import '../../../../../core/models/ride/ride_summary.dart';
import '../../../../../core/models/ui/route_stop_timeline.dart';
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
  });

  final RideSummary summary;
  final BookingCost? bookingCost;
  final bool isCostLoading;

  @override
  Widget build(BuildContext context) {
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
                        const BackArrowButton(),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: const Row(
                        //     children: [
                        //       Icon(
                        //         Icons.share_outlined,
                        //         color: Color(0xFF1B2559),
                        //       ),
                        //       SizedBox(width: 8),
                        //       Text(
                        //         "Share",
                        //         style: TextStyle(color: Color(0xFF1B2559)),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
                                      value:
                                          bookingCost!
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

            Expanded(
              child: SingleChildScrollView(
                child: Opacity(
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
                              parentStatus: summary.status!,
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
                              showTruckCapacity:
                                  summary.packagesAllowed ?? false,
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RouteStopTimelineWidget(
                            headerTitle: 'Route',
                            steps: _buildTimelineSteps(summary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
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
                              const SizedBox(height: 22),
                              ScButton(
                                bgColor: const Color(0xffECF3FE),
                                onClick: () => SocialHelper.sendEmail(
                                  "support@getryto.com",
                                ),
                                // onClick: () => router.push(
                                //   Paths.CHATSUPPORT,
                                //   extra: TicketChatMessages(
                                //     channel: "trip_issues",
                                //     title: "Trip Issues",
                                //   ),
                                // ),
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

  List<RouteStopTimeline> _buildTimelineSteps(RideSummary ride) {
    List<RouteStopTimeline> steps = [];

    // 1. Always start with the Main Trip Origin
    steps.add(
      RouteStopTimeline(
        title: 'Trip Started',
        subtitle: ride.originCity,
        indicatorColor: Colors.grey,
      ),
    );

    // 2. The Current User's Pickup Point
    steps.add(
      RouteStopTimeline(
        title: 'Your Pickup',
        subtitle: 'Coordinates: ${ride.pickupLat}, ${ride.pickupLng}',
        indicatorColor: Colors.green, // Highlighted for the current user
        // If safetyPin is available, you can pass it here as a trailing widget or subtitle note
        // trailing: ride.safetyPin != null
        //     ? Text('PIN: ${ride.safetyPin}')
        //     : null,
      ),
    );

    // 3. Intercept and add other passengers as "Short Stops"
    if (ride.passengers != null) {
      for (var passenger in ride.passengers!) {
        // Skip checking if it's the current user's own record to avoid duplication
        if (passenger.id == ride.booking?.id) continue;

        // Show a unified "Short Stop" for intercepting passengers
        steps.add(
          RouteStopTimeline(
            title: 'Short Stop',
            subtitle: 'Passenger pickup/drop-off point',
            indicatorColor: Colors.amber,
          ),
        );
      }
    }

    // 4. The Current User's Drop-off Point
    steps.add(
      RouteStopTimeline(
        title: 'Your Drop-off',
        subtitle: 'Coordinates: ${ride.dropoffLat}, ${ride.dropoffLng}',
        indicatorColor: Colors.orange,
      ),
    );

    // 5. Overall Trip End
    steps.add(
      RouteStopTimeline(
        title: 'Final Destination',
        subtitle: ride.destinationCity,
        indicatorColor: Colors.grey,
      ),
    );

    return steps;
  }
}
