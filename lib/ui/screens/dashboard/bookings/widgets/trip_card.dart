import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../app/app_setup_locator.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../core/models/booking/booking_request.dart';
import '../../../../../core/models/ride/ride.dart';
import '../../../../../core/setups/region_identity_setup.dart';
import '../../../../widgets/booking_cost_selector.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../../../../widgets/customs/svg_widget.dart';

class TripCard extends StatelessWidget {
  final Ride trip;
  final VoidCallback? onTap;
  final VoidCallback? onRebook;

  const TripCard({super.key, required this.trip, this.onTap, this.onRebook});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM');
    final region = sl<RegionIdentity>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgWidget(
              // assetName: trip.type == TripType.ride
              //     ? AppIcons.car
              //     : AppIcons.boxOutlined,
              assetName: AppIcons.boxOutlined,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        dateFormat.format(trip.departureDate!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        " • ${trip.departureTime}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${trip.originCity} → ${trip.destinationCity}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  BookingCostSelector(
                    request: BookingRequest(
                      vehicleId: trip.vehicle?.id,
                      tripId: trip.id,
                      seats: trip.passengerSeats,
                      pickupLocation: trip.pickupCoord,
                      dropoffLocation: trip.dropOffCoord,
                      originLocation: trip.originCoord,
                      destinationLocation: trip.destCoord,
                      bookingLocation: region.country,
                    ),
                    builder: (context, response) => CurrencyFormatterWidget(
                      amount: "${response.seatPrice?.formatted}",
                      // style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: onRebook,
              icon: SvgWidget(assetName: AppIcons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
