import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/trip_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/scrollable/grouped_list_view.dart';
import 'booking_details_screen.dart';

class BookingHistoriesScreen extends StatefulWidget {
  const BookingHistoriesScreen({super.key});

  @override
  State<BookingHistoriesScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<BookingHistoriesScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
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
              // indicator: UnderlineTabIndicator(),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 1,
              indicatorWeight: .5,
              tabs: [
                Tab(text: "Active"),
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
              ],
            ),

            ///Body
            SizedBox(height: 26.36),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GroupedTripList(
                    trips: Trip.mockTrips,
                    onRebook: (trip) {
                      debugPrint('Rebook ${trip.from} → ${trip.to}');
                    },
                    onTap: (trip) {
                      debugPrint('Goto ${trip.from} → ${trip.to}');
                      context.push(Paths.BOOKINGHISTORYDETAIL, extra: trip);
                    },
                  ),
                  GroupedTripList(
                    trips: Trip.mockUpcomingTrips,
                    onRebook: (trip) {
                      debugPrint('Rebook ${trip.from} → ${trip.to}');
                    },
                    onTap: (trip) {
                      debugPrint('Goto ${trip.from} → ${trip.to}');
                      context.push(Paths.BOOKINGHISTORYDETAIL, extra: trip);
                    },
                  ),
                  GroupedTripList(
                    trips: Trip.mockPastTrips,
                    onRebook: (trip) {
                      debugPrint('Rebook ${trip.from} → ${trip.to}');
                    },
                    onTap: (trip) {
                      debugPrint('Goto ${trip.from} → ${trip.to}');
                      context.push(Paths.BOOKINGHISTORYDETAIL, extra: trip);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
