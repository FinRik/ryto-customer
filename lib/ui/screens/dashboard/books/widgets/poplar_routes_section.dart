import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';

class PoplarRoutesSection extends StatelessWidget {
  const PoplarRoutesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
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
            trailing: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xff292D32), width: 1.5),
              ),
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 11,
                color: Color(0xff292D32),
              ),
            ),
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
      ),
    );
  }
}
