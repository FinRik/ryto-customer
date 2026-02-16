import 'package:flutter/material.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';

class PoplarRoutesSection extends StatelessWidget {
  const PoplarRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Routes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomTileWidget(
            title: "Lagos → Ibadan",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomTileWidget(
            title: "Abuja → Kaduna",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomTileWidget(
            title: "Lagos → Benin",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomTileWidget(
            title: "Abuja → Kaduna",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
          CustomTileWidget(
            title: "Lagos → Benin",
            subtitle: "2h 30m",
            svgIcon: AppSvgs.location,
          ),
        ],
      );
  }
}
