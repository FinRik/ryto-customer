import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../app/res/images.dart';
import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/lat_lng.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/bookings/trip_list_item.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/bookings/trip_route_card.dart';
import 'bloc/package_bloc.dart';

class PackagesAvailableTripsScreen extends StatefulWidget {
  const PackagesAvailableTripsScreen({super.key, required this.args});

  final AvailableTripsArgs args;

  @override
  State<PackagesAvailableTripsScreen> createState() =>
      _AvailableTripsScreenState();
}

class _AvailableTripsScreenState extends State<PackagesAvailableTripsScreen> {
  final region = sl<RegionIdentity>();
  @override
  void initState() {
    super.initState();
    context.read<PackageBloc>().add(
      FetchAvailablePackageRequested(
        originCity: widget.args.originCity,
        destinationCity: widget.args.destinationCity,
        departureDate: widget.args.departureDate,
        passengerSeats: widget.args.passengerSeats,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF9F9F9),
        body: BlocBuilder<PackageBloc, PackageState>(
          builder: (context, state) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 11,
                  ),
                  decoration: const BoxDecoration(color: Color(0xff002252)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TripRouteCard(
                        origin:
                            widget.args.originCity == null ||
                                widget.args.originCity!.isEmpty
                            ? 'Not Selected'
                            : widget.args.originCity!,
                        destination:
                            widget.args.destinationCity == null ||
                                widget.args.destinationCity!.isEmpty
                            ? 'Not Selected'
                            : widget.args.destinationCity!,
                        onEdit: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.args.departureDate == null || widget.args.departureDate!.isEmpty ? 'No Date Selected' : widget.args.departureDate}  > ${widget.args.passengerSeats ?? 1} Passengers",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(PackageState state) {
    // 1. Loading State (Only show if we don't have trips yet)
    if (state.tripsStatus == AvailableTripsStatus.loading &&
        state.availableTrips.isEmpty) {
      return const Center(child: CircularIndicator());
    }

    // 2. Failure State (Only show if list is empty)
    if (state.tripsStatus == AvailableTripsStatus.failure &&
        state.availableTrips.isEmpty) {
      return Center(
        child: Text(
          state.errorMessage ?? "Unable to load trips. Please try again.",
        ),
      );
    }

    // 3. Success State (or data exists)
    final trips = state.availableTrips;

    if (trips.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 23.33),
          Text("${trips.length} Trips Available"),
          const SizedBox(height: 23.33),
          Expanded(
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return TripListItem(
                  ride: trip,
                  country: region.country,
                  onTap: () {
                    context.read<PackageBloc>().add(
                      UpdatePackageProgress(
                        BookingRequest(
                          originLocation: LatLng(
                            lat: trip.originLat!,
                            lng: trip.originLng!,
                            address: trip.originCity,
                          ),
                          destinationLocation: LatLng(
                            lat: trip.destinationLng!,
                            lng: trip.destinationLat!,
                            address: trip.destinationCity,
                          ),
                          pickupLocation: LatLng(
                            lat: trip.pickupLat!,
                            lng: trip.pickupLng!,
                          ),
                          dropoffLocation: LatLng(
                            lat: trip.dropoffLat!,
                            lng: trip.dropoffLng!,
                          ),
                          tripId: trip.id,
                          bookingLocation: region.country,
                          vehicleId: trip.vehicle?.id,
                        ),
                      ),
                    );
                    context.push(Paths.ADDPACKAGEDETAIL, extra: trip);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 65),
          Container(
            decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
              color: Colors.white,
              border: Border.all(color: const Color(0xffE7E8E9)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 27.5, vertical: 24),
            child: Column(
              children: [
                Image.asset(AppImages.car, height: 100),
                HeaderText(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  label: "No drivers available yet?",
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  subText: "Turn on alerts and we’ll notify you soon.",
                  subTextStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  centerSubtitle: true,
                ),
                Button(text: "Notify me when available", onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
