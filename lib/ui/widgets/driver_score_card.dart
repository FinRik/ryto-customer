import 'package:flutter/material.dart';

import '../../app/app_setup_locator.dart';
import '../../app/res/icons.dart';
import '../../core/enums/bottom_sheet_type.dart';
import '../../core/models/ride/driver.dart';
import '../../core/models/ride/vehicle.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../../utils/helpers/call_service_util.dart';
import '../styles/app_decorations.dart';
import 'customs/driver_profile_card.dart';
import 'customs/svg_widget.dart';

class DriverScoreCard extends StatelessWidget {
  const DriverScoreCard({
    super.key,
    required this.tripId,
    required this.driver,
    required this.vehicle,
    this.showTruckCapacity = false,
  });
  final int tripId;
  final Driver driver;
  final Vehicle vehicle;
  final bool showTruckCapacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DriverProfileCard(
          driver: driver,
          vehicle: vehicle,
          showVerifiedIcon: true,
          trailing: Row(
            children:
                [
                      AppIcons.chat,
                      // AppIcons.call
                    ]
                    .map(
                      (e) => GestureDetector(
                        onTap: () async {
                          if (e == AppIcons.chat) {
                            await sl<BottomSheetService>()
                                .showCustomBottomSheet(
                                  variant: BottomSheetType.chat,
                                  data: {
                                    "tripId": tripId,
                                    'participantId': driver.id,
                                  },
                                );
                          } else {
                            CallServiceUtil.makePhoneCall(driver.phone!);
                          }
                        },
                        child: Row(
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
                      ),
                    )
                    .toList(),
          ),
        ),
        DriverProfileCard(
          driver: driver,
          vehicle: vehicle,
          leading: SvgWidget(assetName: AppIcons.car),
          showVerifiedIcon: false,
          trailing: SizedBox(),
          titleText: vehicle.makeModel,
          subtitleWidget: Row(
            children: [
              Text(
                vehicle.color,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color((0xff4B5563)),
                ),
              ),
              if (vehicle.plateNumber != null) ...[
                SizedBox(width: 4),
                CircleAvatar(radius: 2.45, backgroundColor: Colors.black),
                SizedBox(width: 4),
                Text(vehicle.plateNumber ?? ""),
              ],
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
                        color: Color((0xff838794)),
                      ),
                      children: [
                        TextSpan(
                          text: "Medium ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color((0xff222328)),
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
