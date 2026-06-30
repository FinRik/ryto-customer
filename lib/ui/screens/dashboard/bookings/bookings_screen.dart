import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/models/ride/ride.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../widgets/app_bars/custom_app_bar.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import '../../../widgets/scrollable/grouped_list_view.dart';
import 'bloc/bookings_bloc.dart';
import 'widgets/booking_feedback_widget.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<BookingsScreen>
    with TickerProviderStateMixin {
  final region = sl<RegionIdentity>();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    // Fetch initial data
    _fetchTrips(0);

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        _fetchTrips(tabController.index);
      }
    });
  }

  void _fetchTrips(int index) {
    final statuses = ["SCHEDULED", "COMPLETED", "CANCELED"];
    context.read<BookingsBloc>().add(
      LoadUserTrips(
        status: statuses[index],
        searchParams: {'country': region.country},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(removeHorizPadding: true),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Trips",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),

                  Tooltip(
                    message: "widget.labelTip",
                    child: const Icon(
                      Icons.info_outline,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              dividerColor: Colors.transparent,
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 1,
              indicatorWeight: .5,
              tabs: const [
                Tab(text: "Pending"),
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
              ],
            ),

            ///Body
            SizedBox(height: 26.36),
            Expanded(
              child: BlocBuilder<BookingsBloc, BookingsState>(
                // Optimization: Only rebuild this screen when list-related data changes
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.trips != current.trips,
                builder: (context, state) {
                  if (state.status == BookingsStatus.loading &&
                      state.trips.isEmpty) {
                    return const Center(child: CircularIndicator());
                  }

                  // 2. Error state
                  if (state.status == BookingsStatus.failure &&
                      state.trips.isEmpty) {
                    return BookingsFeedback(
                      title: "Something went wrong",
                      message:
                          state.errorMessage ?? "We couldn't load your trips.",
                      icon: Icons.error_outline,
                      onRetry: () => _fetchTrips(tabController.index),
                    );
                  }

                  return Stack(
                    children: [
                      TabBarView(
                        controller: tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // PENDING/SCHEDULED
                          _TripList(trips: state.trips),

                          // UPCOMING/COMPLETED
                          _TripList(trips: state.trips),

                          // PAST/CANCELED
                          _TripList(trips: state.trips),
                        ],
                      ),
                      // Optional: Show a linear progress bar at the top if refreshing
                      if (state.status == BookingsStatus.loading &&
                          state.trips.isNotEmpty)
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(minHeight: 2),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripList extends StatelessWidget {
  final List<Ride> trips;

  const _TripList({required this.trips});

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_filled_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              "No trips found in this category.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GroupedTripList(
      trips: trips,
      onTap: (trip) => context.push(Paths.BOOKINGDETAIL, extra: "${trip.id}"),
      // onRebook: (trip) => debugPrint('Rebook logic here'),
    );
  }
}
