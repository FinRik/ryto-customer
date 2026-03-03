import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../../../core/models/trip_model.dart';
import '../../screens/dashboard/booking_history/widgets/trip_card.dart';


class GroupedTripList extends StatelessWidget {
  final List<Trip> trips;
  final Function(Trip)? onTap;
  final Function(Trip)? onRebook;

  const GroupedTripList({
    super.key,
    required this.trips,
    this.onTap,
    this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Trip, String>(
      elements: trips,
      groupBy: (trip) => DateFormat('MMMM yyyy').format(trip.date),
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
      itemComparator: (a, b) => b.date.compareTo(a.date),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: false,
      floatingHeader: false,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
