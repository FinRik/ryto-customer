import 'package:flutter/material.dart';
import 'package:ryto_customer/core/models/ui/route_stop_timeline.dart';
import 'package:ryto_customer/ui/styles/app_decorations.dart';
import 'package:ryto_customer/ui/widgets/customs/svg_widget.dart';

import '../../../../app/res/icons.dart';
import '../../../../core/models/trip_model.dart';
import '../../../../core/models/ui/passenger.dart';
import '../../../../core/models/ui/timeline_step.dart';
import '../../../../core/models/ui/trip_item_model.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/buttons/social_sign_in_button.dart';
import 'widgets/route_stop_timeline_item.dart';
import 'widgets/driver_score_card.dart';
import 'widgets/passengers_expandable_section.dart';
import 'widgets/vertical_time_line_item.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.trip});

  final Trip trip;

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
                  // Background image/container
                  Container(
                    height: 225,
                    width: double.infinity,
                    color: Colors.green,
                  ),

                  // Back button
                  Positioned(
                    top: 12,
                    left: 8,
                    right: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [const BackArrowButton()],
                    ),
                  ),

                  // Bottom trip info panel
                  Positioned(
                    bottom: 0,
                    left: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                        SizedBox(height: 17.8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Color(0xff222328),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Trip stats
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  _TripInfoItem(
                                    title: "Estimated arrival",
                                    value: "10:30 AM",
                                  ),
                                  _TripInfoItem(
                                    title: "ETA",
                                    value: "45 min",
                                    alignment: Alignment.center,
                                  ),
                                  _TripInfoItem(
                                    title: "Distance",
                                    value: "62 km",
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              const LinearProgressIndicator(value: 0.9),
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
                    SizedBox(height: 19),
                    PassengersExpandableSection(
                      passengers: Passenger.passengers,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: VerticalTimeline(
                        headerTitle: 'Trip Status',
                        steps: TimelineStep.tripSteps,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DriverScoreCard(
                        model: TripItemModel.driverDetail,
                        showTruckCapacity: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RouteStopTimelineWidget(
                        headerTitle: 'Route',
                        steps: RouteStopTimeline.routeSteps,
                        indicatorSize: 14,
                        lineThickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: AppDecoration.roundedOutlinedRadius16,
                            padding: EdgeInsets.all(16),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: AppDecoration.roundedOutlinedRadius16
                                  .copyWith(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Color(0xffF59F0A).withOpacity(.10),
                                  ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgWidget(assetName: AppIcons.warning),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: "Your Safety PIN is ",
                                        children: [
                                          TextSpan(
                                            text: "4729. ",
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
                          SizedBox(height: 22),
                          ScButton(
                            bgColor: Color(0xffECF3FE),
                            onClick: () {},
                            btnText: "Emergency Support",
                            btnTextStyle: TextStyle(color: Color(0xff0846AA)),
                          ),
                          SizedBox(height: 17),
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
              child: SocialSignInButton(
                onTap: () {},
                isCenterAligned: true,
                borderColor: Color(0xff0060EB),
                text: "Message",
                // icon: AppIcons.shareOutlined,
                btnTextStyle: TextStyle(color: Color(0xff0060EB)),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ScButton(
                bgColor: Color(0xffEBF1FF),
                onClick: () {},
                btnText: "Call",
                btnTextStyle: TextStyle(color: Color(0xff0060EB)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripInfoItem extends StatelessWidget {
  const _TripInfoItem({
    required this.title,
    required this.value,
    this.alignment = Alignment.centerLeft,
  });

  final String title;
  final String value;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment == Alignment.centerLeft
          ? CrossAxisAlignment.start
          : alignment == Alignment.centerRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
