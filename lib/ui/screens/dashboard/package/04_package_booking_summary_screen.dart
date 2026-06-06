import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/res/svgs.dart';
import '../../../../core/models/ride/ride.dart';
import '../../../../core/models/ui/trip_stop.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/buttons/social_sign_in_button.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../trip_setup/widgets/trip_stop_timeline.dart';
import 'bloc/package_bloc.dart';
import 'widgets/location_detail_card.dart';

class PackageBookingSummaryScreen extends StatelessWidget {
  const PackageBookingSummaryScreen({super.key, required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackageBloc, PackageState>(
      builder: (context, state) {
        final response = state.scheduleResponse;
        final request = state.request;

        return Scaffold(
          backgroundColor: const Color(0xff0060EB),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 51,
                bottom: 31,
              ),
              child: Column(
                children: [
                  // --- Success Header ---
                  SvgPicture.asset(AppSvgs.package),
                  const SizedBox(height: 24),
                  const HeaderText(
                    label: "Package Booked",
                    subText: "Your delivery has been scheduled successfully",
                    crossAxisAlignment: CrossAxisAlignment.center,
                    labelStyle: TextStyle(
                      color: Color(0xffE3FB20),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    subTextStyle: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 31),

                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: TripStopTimeline(
                      duration: "2h 30m",
                      stops: [
                        TripStop(
                          location: state.request.pickupLocation!,
                          city: state.request.originLocation?.address ?? "",
                          time: "08:00 AM",
                          indicatorColor: Colors.blue,
                        ),
                        TripStop(
                          location: state.request.dropoffLocation!,
                          city:
                              state.request.destinationLocation?.address ?? "",
                          time: "10:30 AM",
                          indicatorColor: Colors.green,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomCardWidget(
                    title: "Pickup & Delivery",
                    border: Border.all(width: 0, style: BorderStyle.none),
                    bgColor: Colors.white,
                    child: Column(
                      children: [
                        LocationDetailCard(
                          locationName:
                              "Pickup: ${request.originLocation?.address}",
                          coord: request.pickupLocation!,
                        ),
                        const SizedBox(height: 8),
                        LocationDetailCard(
                          locationName:
                              "Drop-off: ${request.destinationLocation?.address}",
                          coord: request.dropoffLocation!,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- Safety PIN Section ---
                  _buildSafetyPinCard(response!.bookingSafetyPin!),

                  const SizedBox(height: 32),

                  // --- Action Buttons ---
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSafetyPinCard(String pin) {
    return Container(
      decoration: AppDecoration.roundedOutlinedRadius16.copyWith(
        color: const Color(0xff003A8D),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppSvgs.shieldTick),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your safety PIN",
                    style: TextStyle(fontSize: 13, color: Color(0xffF9F9F9)),
                  ),
                  Text(
                    pin,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xffE3FB20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Share this PIN with driver when boarding",
            style: TextStyle(fontSize: 12, color: Color(0xffF9F9F9)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ScButton(
            bgColor: Colors.white,
            onClick: () =>
                router.push(Paths.BOOKINGDETAIL, extra: "${ride.id}"),
            btnText: "Track Package",
            btnTextStyle: const TextStyle(
              color: Color(0xff0060EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // const SizedBox(width: 12),
        // Expanded(
        //   child: SocialSignInButton(
        //     onTap: () {
        //       // Share logic
        //     },
        //     text: "Share",
        //     icon: AppIcons.shareOutlined,
        //   ),
        // ),
      ],
    );
  }
}
