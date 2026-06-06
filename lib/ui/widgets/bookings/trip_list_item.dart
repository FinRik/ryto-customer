import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ryto_customer/ui/styles/app_decorations.dart';

import '../../../app/app_setup_locator.dart';
import '../../../app/res/icons.dart';
import '../../../app/res/svgs.dart';
import '../../../core/models/booking/booking_request.dart';
import '../../../core/models/lat_lng.dart';
import '../../../core/models/ride/ride.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../arrival_time_widget.dart';
import '../booking_cost_selector.dart';
import '../currency_formatter_widget.dart';
import '../customs/svg_widget.dart';

class TripListItem extends StatelessWidget {
  final Ride ride;
  final Function()? onTap;
  final String country;

  const TripListItem({super.key, required this.ride, this.onTap, required this.country});

  @override
  Widget build(BuildContext context) {
    final int seatsLeft =
        (ride.passengerSeats ?? 0) - (ride.passengers?.length ?? 0);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xffE7E8E9)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgWidget(assetName: AppIcons.users),
                            const SizedBox(width: 4),
                            Text("$seatsLeft seats left"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          decoration: AppDecoration.roundedOutlinedRadius100
                              .copyWith(
                                color: const Color(0xff34C759).withOpacity(.1),
                              ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              SvgWidget(
                                assetName: AppIcons.lightning,
                                iconColor: const Color(0xff34C759),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "Instant Confirm",
                                style: TextStyle(
                                  color: Color(0xff34C759),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BookingCostSelector(
                          request: BookingRequest(
                            vehicleId: ride.vehicle?.id,
                            tripId: ride.id,
                            seats: ride.passengerSeats,
                            pickupLocation: LatLng(
                              lng: ride.pickupLng!,
                              lat: ride.pickupLat!,
                            ),
                            dropoffLocation: LatLng(
                              lat: ride.dropoffLat!,
                              lng: ride.dropoffLng!,
                            ),
                            originLocation: LatLng(
                              lat: ride.originLat!,
                              lng: ride.originLng!,
                            ),
                            destinationLocation: LatLng(
                              lat: ride.destinationLat!,
                              lng: ride.destinationLng!,
                            ),
                            bookingLocation: country,
                          ),
                          builder: (context, response) =>
                              CurrencyFormatterWidget(
                                amount: "${response.seatPrice!.formatted!}",
                                symbolStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        ),
                        const Text("Per Seat", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Time and Duration Row
                ArrivalTimeWidget(
                  sourceLat: ride.originLat!,
                  sourceLng: ride.originLng!,
                  destLat: ride.destinationLat!,
                  destLng: ride.destinationLng!,
                  departureTime: ride.departureTime!,
                  departureDate: ride.departureDate!,
                  builder: (cxt, response) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimeColumn(ride.departureTime ?? "--:--", "Depart"),
                      Column(
                        children: [
                          Text(
                            response.formattedDuration,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Container(
                            height: 1,
                            width: 40,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      _buildTimeColumn(response.formattedArrivalTime, "Arrive"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                /// Route Locations
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
                    color: const Color(0xFFF9F9F9),
                    border: Border.all(style: BorderStyle.none),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ride.originCity ?? "Origin",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset(
                          AppIcons.arrowForward,
                          width: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ride.destinationCity ?? "Destination",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                /// Driver and Vehicle Info
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
                    color: const Color(0xFFF9F9F9),
                    border: Border.all(style: BorderStyle.none),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF0060EB),
                        child: Text(
                          ride.avatarText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ride.driverName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF33363E),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                if (ride.isVerified)
                                  SvgWidget(assetName: AppSvgs.checkMark),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Color(0xFFFFB853),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ride.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const CircleAvatar(
                                  radius: 2,
                                  backgroundColor: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${ride.tripCount} Trips",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Trailing Vehicle Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildVehicleDetail(AppIcons.car, ride.vehicleInfo),
                          const SizedBox(height: 4),
                          _buildVehicleDetail(
                            AppIcons.luggage,
                            ride.packagesAllowed == true
                                ? "Allowed"
                                : "No Luggage",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimeColumn(String time, String label) {
    return Column(
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVehicleDetail(String icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgWidget(assetName: icon, width: 12),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: Color(0xFF666E7A)),
        ),
      ],
    );
  }
}
