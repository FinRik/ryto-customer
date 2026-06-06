import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../../core/models/ride/ride.dart';
import '../../screens/dashboard/bookings/widgets/trip_card.dart';

class GroupedTripList extends StatelessWidget {
  final List<Ride> trips;
  final Function(Ride)? onTap;
  final Function(Ride)? onRebook;

  const GroupedTripList({
    super.key,
    required this.trips,
    this.onTap,
    this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Ride, String>(
      elements: trips,
      groupBy: (trip) => DateFormat('MMMM yyyy').format(trip.createdAt!),
      groupSeparatorBuilder: (String groupValue) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          groupValue,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      itemBuilder: (context, trip) {
        return TripCard(
          trip: trip,
          onTap: () => onTap?.call(trip),
          onRebook: () => onRebook?.call(trip),
        );
      },
      itemComparator: (a, b) => b.createdAt!.compareTo(a.createdAt!),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: false,
      floatingHeader: false,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
