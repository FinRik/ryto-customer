import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../core/models/ride/ride.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../bloc/bookings_bloc.dart';

class TripCard extends StatelessWidget {
  final Ride trip;
  final VoidCallback? onTap;
  // final VoidCallback? onRebook;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
    // this.onRebook
  });

  @override
  Widget build(BuildContext context) {
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
                        (trip.departureDate),
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
                  if (trip.status == 'SCHEDULED')
                    BlocBuilder<BookingsBloc, BookingsState>(
                      buildWhen: (prev, curr) =>
                          prev.tripCosts[trip.id] != curr.tripCosts[trip.id],
                      builder: (context, state) {
                        final costResponse = state.tripCosts[trip.id];
                        if (costResponse == null) {
                          return const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          );
                        }
                        return CurrencyFormatterWidget(
                          amount: costResponse.surgePercentageFormatted != null
                              ? "${costResponse.finalPrice?.formatted}"
                              : "${costResponse.totalPrice?.formatted}",
                        );
                      },
                    ),
                ],
              ),
            ),

            // IconButton(
            //   onPressed: onRebook,
            //   icon: SvgWidget(assetName: AppIcons.refresh),
            // ),
          ],
        ),
      ),
    );
  }
}
