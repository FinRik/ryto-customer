import 'package:flutter/material.dart';

import '../../../styles/app_decorations.dart';
import 'widgets/packages_header_section.dart';
import 'widgets/packages_routes_section.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

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
            //       height: 350,
            //       width: double.infinity,
            //       decoration: AppDecoration.dashboardDeco,
            //     ),
            //
            //     /// OVERLAY CARD
            //     const Positioned(
            //       top: 40,
            //       left: 24,
            //       right: 24,
            //       child: PackagesHeaderSection(),
            //     ),
            //   ],
            // ),
            //
            // const SizedBox(height: 240),

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
                  child: PackagesHeaderSection(),
                ),
              ],
            ),

            const SizedBox(height: 27),

            PackagesRoutesSection(),
          ],
        ),
      ),
    );
  }
}
