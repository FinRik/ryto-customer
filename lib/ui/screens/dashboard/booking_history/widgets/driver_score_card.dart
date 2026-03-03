import 'package:flutter/material.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../core/models/ui/trip_item_model.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/customs/driver_profile_card.dart';
import '../../../../widgets/customs/svg_widget.dart';

class DriverScoreCard extends StatelessWidget {
  const DriverScoreCard({
    super.key,
    required this.model,
    this.showTruckCapacity = false,
  });
  final TripItemModel model;
  final bool showTruckCapacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DriverProfileCard(
          model: TripItemModel.driverDetail,
          showVerifiedIcon: true,
          trailing: Row(
            children: [AppIcons.chat, AppIcons.call]
                .map(
                  (e) => Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xffE6EFFD),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgWidget(assetName: e),
                        ),
                      ),
                      if (e == AppIcons.chat) SizedBox(width: 5),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        DriverProfileCard(
          model: model,
          leading: SvgWidget(assetName: AppIcons.car),
          showVerifiedIcon: false,
          trailing: SizedBox(),
          titleText: "Toyota Camry 2020",
          subtitleWidget: Row(
            children: [
              Text(
                "Silver",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color((0xff4B5563))
                ),
              ),
              SizedBox(width: 4),
              CircleAvatar(radius: 2.45, backgroundColor: Colors.black),
              SizedBox(width: 4),
              Text("ABC 123 XY"),
            ],
          ),
        ),
        if (showTruckCapacity)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6.5),
            decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
              color: Color(0xffF6FEBA),
              border: Border.all(style: BorderStyle.none),
            ),
            child: Row(
              children: [
                SvgWidget(assetName: AppIcons.luggage),
                SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Trunk capacity: ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color((0xff838794))
                      ),
                      children: [
                        TextSpan(
                          text: "Medium ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                              color: Color((0xff222328))
                          ),
                        ),
                        TextSpan(text: "(fits carry-on suitcase)"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
