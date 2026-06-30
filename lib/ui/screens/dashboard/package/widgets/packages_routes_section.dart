import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../../core/models/popular_route.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../widgets/customs/custom_route_tile_widget.dart';
import '../../../../widgets/loaders/circular_indicator.dart';

class PackagesRoutesSection extends StatelessWidget {
  const PackagesRoutesSection({
    super.key,
    required this.routes,
    required this.isLoading,
  });

  final List<PopularRoute> routes;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular delivery Routes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (isLoading && routes.isEmpty)
            const Center(child: CircularIndicator())
          else if (!isLoading && routes.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "No popular delivery routes available at the moment.",
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final route = routes[index];
                return CustomRouteTileWidget(
                  title: "${route.originCity} → ${route.destinationCity}",
                  titleTextStyle: TextStyle(fontSize: 16),
                  subtitle: "Estimated time unavailable",
                  svgIcon: AppSvgs.location,
                  onTap: () => context.push(
                    Paths.AVAILABLETRIPS,
                    extra: AvailableTripsArgs(
                      originCity: route.originCity,
                      destinationCity: route.destinationCity,
                      path: Paths.ADDPACKAGEDETAIL,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
