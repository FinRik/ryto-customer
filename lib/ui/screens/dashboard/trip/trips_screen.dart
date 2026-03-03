import 'package:flutter/material.dart';

import '../../../styles/app_decorations.dart';
import '../../../widgets/customs/custom_tile_widget.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/poplar_routes_section.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<TripsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER STACK
            // Stack(
            //   clipBehavior: Clip.none,
            //   children: [
            //     Container(
            //       height: 400,
            //       width: double.infinity,
            //       decoration: AppDecoration.dashboardDeco,
            //     ),
            //
            //     /// OVERLAY CARD
            //     Positioned(
            //       top: 40,
            //       left: 24,
            //       right: 24,
            //       child: DashboardHeader(),
            //     ),
            //   ],
            // ),
            Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  child: Container(
                    height: 400,
                    decoration: AppDecoration.dashboardDeco,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
                  child: DashboardHeader(),
                ),
              ],
            ),

            const SizedBox(height: 27),

            /// Popular Routes
            PoplarRoutesSection(),
          ],
        ),
      ),
    );
  }
}
