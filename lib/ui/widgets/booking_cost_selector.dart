import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/booking/booking_request.dart';
import '../../core/models/booking/booking_cost.dart';
import '../../core/repos/trips_repo.dart';
import '../blocs/booking_cost/booking_cost_cubit.dart';
import 'loaders/circular_indicator.dart';

typedef BookingCostBuilder =
    Widget Function(BuildContext context, BookingCost summary);

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
      child: BlocBuilder<BookingCostCubit, AsyncSnapshot<BookingCost>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot.data!);
          }

          return const CircularIndicator();
        },
      ),
    );
  }
}
