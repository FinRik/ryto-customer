import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../widgets/customs/custom_route_tile_widget.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';

class PackagesRoutesSection extends StatelessWidget {
  const PackagesRoutesSection({super.key});

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
          CustomRouteTileWidget(
            title: "Lagos → Ibadan",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomRouteTileWidget(
            title: "Abuja → Kaduna",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomRouteTileWidget(
            title: "Lagos → Benin",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomRouteTileWidget(
            title: "Abuja → Kaduna",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomRouteTileWidget(
            title: "Lagos → Benin",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
        ],
      ),
    );
  }
}
