import 'package:flutter/material.dart';

import '../../../app/res/icons.dart';
import '../../../app/res/svgs.dart';
import '../../../core/models/ui/trip_item_model.dart';
import '../../styles/app_decorations.dart';
import 'svg_widget.dart';

class DriverProfileCard extends StatelessWidget {
  const DriverProfileCard({
    super.key,
    required this.model,
    required this.showVerifiedIcon,
    this.leading,
    this.trailing,
    this.subtitleWidget, this.titleText,
  });

  final TripItemModel model;
  final bool showVerifiedIcon;
  final Widget? leading, trailing;
  final String? titleText;
  final Widget? subtitleWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
        color: const Color(0xFFF9F9F9),
        border: BoxBorder.all(style: BorderStyle.none),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Avatar
          leading ??
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF0060EB),
                child: Text(
                  model.avatarText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

          const SizedBox(width: 8),

          /// Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title Row
                Row(
                  children: [
                    Text(
                      titleText??model.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF33363E),
                      ),
                    ),
                    if (model.isVerified && showVerifiedIcon)
                      SizedBox(width: 4),
                    if (model.isVerified && showVerifiedIcon)
                      SvgWidget(assetName: AppSvgs.checkMark),
                  ],
                ),

                const SizedBox(height: 4),

                /// Rating
                subtitleWidget ??
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFFB853),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          model.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 4),
                    CircleAvatar(radius: 2.45, backgroundColor: Colors.black),
                    SizedBox(width: 4),
                    Text("234 Trips"),
                  ],
                ),
              ],
            ),
          ),

          /// Trailing Vehicle Icon
          trailing ??
              Column(
                children: [
                  Row(
                    children: [
                      SvgWidget(assetName: AppIcons.car),
                      SizedBox(width: 6),
                      Text("Honda Accord", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                  Row(
                    children: [
                      SvgWidget(assetName: AppIcons.luggage),
                      SizedBox(width: 6),
                      Text("Honda Accord", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
