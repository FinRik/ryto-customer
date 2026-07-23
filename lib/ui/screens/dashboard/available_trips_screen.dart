import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_setup_locator.dart';
import '../../../core/models/ride/ride.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../../blocs/available_routes/available_routes_bloc.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/customs/event_state_widgets.dart';
import '../../widgets/loaders/circular_indicator.dart';
import '../../widgets/bookings/trip_list_item.dart';
import '../../widgets/bookings/trip_route_card.dart';

class AvailableTripsScreen extends StatefulWidget {
  const AvailableTripsScreen({super.key, required this.args});
  final AvailableTripsArgs args;

  @override
  State<AvailableTripsScreen> createState() => _AvailableTripsScreenState();
}

class _AvailableTripsScreenState extends State<AvailableTripsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getAvailableTrips());
  }

  void getAvailableTrips() {
    final availableTripsBloc = context.read<AvailableTripsBloc>();
    final region = sl<RegionIdentity>();
    availableTripsBloc.add(
      FetchTripsAndCosts({
        'originCity': widget.args.originCity,
        'destinationCity': widget.args.destinationCity,
        'departureDate': widget.args.departureDate,
        'passengerSeats': widget.args.passengerSeats,
        'currency': region.currencyCode,
        'country': region.country,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: SafeArea(
        child: BlocBuilder<AvailableTripsBloc, AvailableTripsState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildHeaderRouteCard(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildScreenContent(state: state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScreenContent({required AvailableTripsState state}) {
    if (state.status == TripsSearchStatus.loading && state.trips.isEmpty) {
      return const Center(child: CircularIndicator());
    }
    if (state.status == TripsSearchStatus.failure) {
      return ErrorStateWidget(
        message: state.errorMessage ?? "Error occurred",
        onRetry: () => getAvailableTrips(),
      );
    }
    if (state.trips.isEmpty) {
      return EmptyStateWidget(
        title: "No drivers available",
        onTap: () {
          router.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your preference has been saved")),
          );
        },
      );
    }

    return ListView.separated(
      itemCount: state.trips.length,
      separatorBuilder: (ctx, index) => SizedBox(height: 14),
      itemBuilder: (context, index) {
        final trip = state.trips[index];
        final cost = state.tripCosts[trip.id];

        return TripListItem(
          ride: trip,
          cost: cost,
          onTap: () => _handleTripSelection(trip),
        );
      },
    );
  }

  void _handleTripSelection(Ride trip) {
    router.push(
      Paths.SETBOOKINGROUTE,
      extra: BookingRouteArgs(ride: trip, path: widget.args.path),
    );
  }

  Widget _buildHeaderRouteCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: BackArrowButton(),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: const Color(0xff002252),
          child: TripRouteCard(
            origin: widget.args.originCity ?? 'Not Selected',
            destination: widget.args.destinationCity ?? 'Not Selected',
            onEdit: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
