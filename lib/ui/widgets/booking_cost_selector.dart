import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/booking/booking_request.dart';
import '../../core/models/booking/booking_summary.dart';
import '../../core/repos/trips_repo.dart';
import '../blocs/booking_cost/booking_cost_cubit.dart';
import 'loaders/circular_indicator.dart';

typedef BookingCostBuilder =
    Widget Function(BuildContext context, BookingSummary summary);

// class BookingCostSelector extends StatefulWidget {
//   final BookingRequest request;
//   final BookingCostBuilder builder;
//
//   const BookingCostSelector({
//     super.key,
//     required this.request,
//     required this.builder,
//   });
//
//   @override
//   State<BookingCostSelector> createState() => _BookingCostSelectorState();
// }
//
// class _BookingCostSelectorState extends State<BookingCostSelector> {
//   late Future<BookingSummary?> _bookingCostFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     final tripsRepo = context.read<TripsRepo>();
//     _bookingCostFuture = tripsRepo.fetchBookingCost(widget.request);
//   }
//
//   @override
//   void didUpdateWidget(covariant BookingCostSelector oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.request != widget.request) {
//       setState(() {
//         _bookingCostFuture = context.read<TripsRepo>().fetchBookingCost(widget.request);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<BookingSummary?>(
//       future: _bookingCostFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularIndicator());
//         }
//
//         if (snapshot.hasError || snapshot.data == null) {
//           return const Center(
//             child: Text("Could not calculate cost. Check connection."),
//           );
//         }
//
//         return widget.builder(context, snapshot.data!);
//       },
//     );
//   }
// }

class BookingCostSelector extends StatelessWidget {
  final BookingRequest request;
  final BookingCostBuilder builder;

  const BookingCostSelector({
    super.key,
    required this.request,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(request),
      create: (context) =>
          BookingCostCubit(context.read<TripsRepo>())..calculateCost(request),
      child: BlocBuilder<BookingCostCubit, BookingCostState>(
        builder: (context, state) {
          if (state is BookingCostLoading) {
            return const Center(child: CircularIndicator());
          }

          if (state is BookingCostError) {
            return Center(child: Text(state.message));
          }

          if (state is BookingCostLoaded) {
            return builder(context, state.summary);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
