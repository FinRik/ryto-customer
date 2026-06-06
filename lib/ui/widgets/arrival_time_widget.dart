import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/arrival_estimate.dart';
import '../../core/repos/arrival_time_repo.dart';
import '../blocs/arrival_time/arrival_time_cubit.dart';
import 'loaders/circular_indicator.dart';

typedef ArrivalBuilder =
    Widget Function(BuildContext context, ArrivalEstimate estimate);

// class ArrivalTimeWidget extends StatefulWidget {
//   final double sourceLat;
//   final double sourceLng;
//   final double destLat;
//   final double destLng;
//   final String departureTime;
//   final DateTime departureDate;
//   final ArrivalBuilder builder;
//
//   const ArrivalTimeWidget({
//     super.key,
//     required this.sourceLat,
//     required this.sourceLng,
//     required this.destLat,
//     required this.destLng,
//     required this.departureTime,
//     required this.departureDate,
//     required this.builder,
//   });
//
//   @override
//   State<ArrivalTimeWidget> createState() => _ArrivalTimeWidgetState();
// }
//
// class _ArrivalTimeWidgetState extends State<ArrivalTimeWidget> {
//   late Future<ArrivalEstimate> _arrivalFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // 1. Grab the repository using context.read instead of inside the build tree
//     final repo = context.read<ArrivalTimeRepo>();
//
//     // 2. Initialize the future exactly once
//     _arrivalFuture = repo.getArrivalData(
//       sLat: widget.sourceLat,
//       sLng: widget.sourceLng,
//       eLat: widget.destLat,
//       eLng: widget.destLng,
//       departureTime: widget.departureTime,
//       departureDate: widget.departureDate,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ArrivalEstimate>(
//       future: _arrivalFuture, // 3. Pass the cached future here
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularIndicator();
//         }
//
//         if (snapshot.hasData) {
//           return widget.builder(context, snapshot.data!);
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         return const CircularIndicator();
//       },
//     );
//   }
// }

class ArrivalTimeWidget extends StatelessWidget {
  final double sourceLat;
  final double sourceLng;
  final double destLat;
  final double destLng;
  final String departureTime;
  final DateTime departureDate;
  final ArrivalBuilder builder;

  const ArrivalTimeWidget({
    super.key,
    required this.sourceLat,
    required this.sourceLng,
    required this.destLat,
    required this.destLng,
    required this.departureTime,
    required this.departureDate,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ArrivalTimeCubit(context.read<ArrivalTimeRepo>())..fetchArrivalData(
            sLat: sourceLat,
            sLng: sourceLng,
            eLat: destLat,
            eLng: destLng,
            departureTime: departureTime,
            departureDate: departureDate,
          ),
      child: BlocBuilder<ArrivalTimeCubit, AsyncSnapshot<ArrivalEstimate>>(
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
