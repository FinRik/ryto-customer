import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/loaders/circular_indicator.dart';
import 'bloc/bookings_bloc.dart';
import 'parts/approve_status_widget.dart';
import 'parts/pending_status_widget.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key, required this.tripId});

  final String tripId;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> with WidgetsBindingObserver {

  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // 2. Register the observer to listen for lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSummary();
    });

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
      case AppLifecycleState.hidden: // Covered for newer Flutter versions
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

  void _startPolling() {
    // Avoid creating multiple parallel timers
    if (_pollingTimer?.isActive ?? false) return;

    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchSummary();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void dispose() {
    // 4. Clean up both the timer and the observer to prevent leaks
    _stopPolling();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (ctx, state) {
        if (state.summaryStatus == SummaryStatus.loading && state.tripSummary == null) {
          return const BaseScaffoldWidget(
            child: Center(child: CircularIndicator()),
          );
        }

        if (state.summaryStatus == SummaryStatus.failure) {
          return BaseScaffoldWidget(
            child: Center(
              child: Text(state.errorMessage ?? "Something went wrong"),
            ),
          );
        }

        final summary = state.tripSummary;
        if (summary == null) {
          return const BaseScaffoldWidget(
            child: Center(child: Text("Trip not found")),
          );
        }

        if (summary.isTripPending) {
          return PendingStatusWidget(summary: summary);
        }

        if (summary.isTripRejected) {
          return PendingStatusWidget(summary: summary);
        }

        return ApproveStatusWidget(summary: summary);
      },
    );
  }
}
