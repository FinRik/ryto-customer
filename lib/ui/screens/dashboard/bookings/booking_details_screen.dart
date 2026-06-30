import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/ride/ride_summary.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/customs/event_state_widgets.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import 'bloc/bookings_bloc.dart';
import 'parts/approve_status_widget.dart';
import 'parts/canceled_status_widget.dart';
import 'parts/pending_status_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key, required this.tripId});

  final String tripId;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen>
    with WidgetsBindingObserver {
  final region = sl<RegionIdentity>();
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // 2. Register the observer to listen for lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSummary());

    _startPolling();
  }

  // 3. Listen to system lifecycle states
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // App is back in focus -> resume polling and fetch immediately
        _fetchSummary();
        _startPolling();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App went to background -> stop timers to save resources
        _stopPolling();
        break;
    }
  }

  void _fetchSummary() {
    if (mounted) {
      context.read<BookingsBloc>().add(LoadTripSummary(widget.tripId));
    }
  }

  void _fetchBookingCost(RideSummary summary) {
    if (mounted) {
      context.read<BookingsBloc>().add(
        LoadBookingCost(
          BookingRequest(
            vehicleId: summary.vehicle?.id,
            tripId: summary.id,
            seats: 1,
            pickupLocation: summary.pickupCoord,
            dropoffLocation: summary.dropOffCoord,
            originLocation: summary.originCoord,
            destinationLocation: summary.destCoord,
            bookingLocation: region.country,
          ),
        ),
      );
    }
  }

  void _startPolling() {
    // Avoid creating multiple parallel timers
    if (_pollingTimer?.isActive ?? false) return;

    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchSummary();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void dispose() {
    _stopPolling();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingsBloc, BookingsState>(
      listenWhen: (prev, curr) =>
          (curr.summaryStatus == SummaryStatus.success &&
              prev.tripSummary?.id != curr.tripSummary?.id) ||
          (prev.status != curr.status),
      listener: (ctx, state) {
        if (state.summaryStatus == SummaryStatus.success &&
            state.tripSummary != null) {
          _fetchBookingCost(state.tripSummary!);
        }

        if (state.status == BookingsStatus.canceled) {
          if (Navigator.canPop(ctx)) {
            Navigator.of(ctx).pop();
          }
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text("Booking canceled successfully"),
              backgroundColor: Colors.green,
            ),
          );
          _fetchSummary();
        }

        if (state.status == BookingsStatus.failure) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Failed to complete action"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      buildWhen: (prev, curr) =>
          prev.summaryStatus != curr.summaryStatus ||
          prev.status != curr.status ||
          prev.tripSummary?.isTripPending != curr.tripSummary?.isTripPending ||
          prev.tripSummary?.isTripRejected !=
              curr.tripSummary?.isTripRejected ||
          prev.bookingCost != curr.bookingCost ||
          prev.costStatus != curr.costStatus,
      builder: (ctx, state) {
        if (state.summaryStatus == SummaryStatus.loading) {
          return BaseScaffoldWidget(
            bgColor: Colors.white,
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: BackArrowButton(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            child: Center(child: CircularIndicator()),
          );
        }

        if (state.summaryStatus == SummaryStatus.failure &&
            state.tripSummary == null) {
          return BaseScaffoldWidget(
            bgColor: Colors.white,
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: BackArrowButton(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            child: Center(
              child: ErrorStateWidget(
                message: state.errorMessage ?? "Something went wrong",
                onRetry: () => _fetchSummary(),
              ),
            ),
          );
        }

        final summary = state.tripSummary;
        if (summary == null) {
          return BaseScaffoldWidget(
            bgColor: Colors.white,
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: BackArrowButton(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            child: Center(
              child: ErrorStateWidget(
                message: "Trip not found",
                onRetry: () => _fetchSummary(),
              ),
            ),
          );
        }

        final isPollingRefresh =
            state.summaryStatus == SummaryStatus.refreshing;
        final isActionLoading = state.status == BookingsStatus.loading;

        return BaseScaffoldWidget(
          removePadding: true,
          bgColor: Colors.white,
          child: Column(
            children: [
              Container(
                child: isPollingRefresh
                    ? const PreferredSize(
                        preferredSize: Size.fromHeight(4.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFFF4F7FE),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF0061FF),
                          ),
                          minHeight: 4.0,
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: _buildStateContent(
                  summary: summary,
                  state: state,
                  isBusy: isActionLoading,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStateContent({
    required RideSummary summary,
    required BookingsState state,
    required bool isBusy,
  }) {
    if (summary.isBookingCanceled) {
      return CanceledStatusWidget(
        summary: summary,
        bookingCost: state.bookingCost,
        isCostLoading: state.costStatus == CostStatus.loading,
      );
    }
    if (summary.isBookingPending || summary.isBookingRejected) {
      return PendingStatusWidget(
        summary: summary,
        bookingCost: state.bookingCost,
        isCostLoading: state.costStatus == CostStatus.loading,
        isActionLoading: isBusy,
      );
    }

    return ApproveStatusWidget(
      summary: summary,
      bookingCost: state.bookingCost,
      isCostLoading: state.costStatus == CostStatus.loading,
    );
  }
}
