import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ryto_customer/ui/widgets/customs/svg_widget.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../core/models/trip_model.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;
  final VoidCallback? onRebook;

  const TripCard({super.key, required this.trip, this.onTap, this.onRebook});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM • HH:mm');

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
              assetName: trip.type == TripType.ride
                  ? AppIcons.car
                  : AppIcons.boxOutlined,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(trip.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${trip.from} → ${trip.to}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₦${trip.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            IconButton(onPressed: onRebook, icon: SvgWidget(assetName: AppIcons.refresh)),
          ],
        ),
      ),
    );
  }
}
