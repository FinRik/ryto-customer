import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/res/svgs.dart';
import '../../../../core/models/ui/trip_stop.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/arrival_time_widget.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../trip_setup/widgets/trip_stop_timeline_item.dart';
import 'widgets/location_detail_card.dart';

class PackageBookingSummaryScreen extends StatelessWidget {
  const PackageBookingSummaryScreen({super.key, required this.args});
  final TripBookingSummaryArgs args;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        router.go(Paths.HOME);
      },
      child: Scaffold(
        backgroundColor: const Color(0xff0060EB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // SvgPicture.asset(AppSvgs.package),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 80,
                  color: Colors.white,
                ),
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
                  centerSubtitle: true,
                ),
                ArrivalTimeWidget(
                  sourceLat: args.ride!.originLat,
                  sourceLng: args.ride!.originLng,
                  destLat: args.ride!.dropoffLat,
                  destLng: args.ride!.dropoffLat,
                  departureDateTime: args.ride!.departureDateTime,
                  builder: (ctx, eta) => Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: TripStopTimeline(
                      duration: eta.formattedDuration,
                      stops: [
                        TripStop(
                          location: args.bookingRequest!.pickupLocation!,
                          city:
                              args.bookingRequest!.originLocation?.address ??
                              "",
                          time: args.ride!.departureTime,
                          indicatorColor: Colors.blue,
                        ),
                        TripStop(
                          location: args.bookingRequest!.dropoffLocation!,
                          city:
                              args
                                  .bookingRequest!
                                  .destinationLocation
                                  ?.address ??
                              "",
                          time: eta.formattedArrivalTime,
                          indicatorColor: Colors.green,
                          isLast: true,
                        ),
                      ],
                    ),
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
                            "Pickup: ${args.bookingRequest!.originLocation?.address}",
                        coord: args.bookingRequest!.pickupLocation!,
                      ),
                      const SizedBox(height: 8),
                      LocationDetailCard(
                        locationName:
                            "Drop-off: ${args.bookingRequest!.destinationLocation?.address}",
                        coord: args.bookingRequest!.dropoffLocation!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // --- Safety PIN Section ---
                _buildSafetyPinCard(args.bookingResponse!.bookingSafetyPin!),
                const SizedBox(height: 40),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
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
    return Column(
      children: [
        Button(
          buttonColor: Colors.white,
          onTap: () =>
              router.push(Paths.BOOKINGDETAIL, extra: "${args.ride?.id}"),
          text: "Track Package",
          textColor: const Color(0xff0060EB),
        ),
        const SizedBox(height: 12),
        Button.outline(
          onTap: () => router.go(Paths.HOME),
          text: "Return to Dashboard",
          border: Border.all(color: Colors.white),
          textColor: Colors.white,
          showSuffixIcon: true,
          suffixIcon: Icons.home,
        ),
      ],
    );
  }
}
