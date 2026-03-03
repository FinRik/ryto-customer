import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ryto_customer/ui/styles/app_decorations.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../app/res/svgs.dart';
import '../../../../../core/models/ui/trip_item_model.dart';
import '../../../../widgets/customs/svg_widget.dart';

class TripListItem extends StatelessWidget {
  final TripItemModel model;
  final Function()? onTap;

  const TripListItem({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              border: BoxBorder.all(width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgWidget(assetName: AppIcons.users),
                            SizedBox(width: 4),
                            Text("2 seats left"),
                          ],
                        ),
                        Container(
                          decoration: AppDecoration.roundedOutlinedRadius100
                              .copyWith(color: Color(0xff34C759).withOpacity(.1)),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              SvgWidget(
                                assetName: AppIcons.lightning,
                                iconColor: Color(0xff34C759),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Instant Confirm",
                                style: TextStyle(color: Color(0xff34C759)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₦9,700",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text("Per Seat"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "18:15",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text("Depart"),
                      ],
                    ),
                    Column(children: [Text("7h 45m")]),
                    Column(
                      children: [
                        Text(
                          "05:00",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text("Depart"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
                    color: const Color(0xFFF9F9F9),
                    border: BoxBorder.all(style: BorderStyle.none),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Ojota Motor Park"),
                      SvgPicture.asset(AppIcons.arrowForward),
                      Text("Iwo Road Ibadan"),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
                    color: const Color(0xFFF9F9F9),
                    border: BoxBorder.all(style: BorderStyle.none),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Avatar
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
                                  model.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF33363E),
                                  ),
                                ),
                                SizedBox(width: 4),
                                if (model.isVerified)
                                  SvgWidget(assetName: AppSvgs.checkMark),
                              ],
                            ),

                            const SizedBox(height: 4),

                            /// Rating
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
                                CircleAvatar(
                                  radius: 2.45,
                                  backgroundColor: Colors.black,
                                ),
                                SizedBox(width: 4),
                                Text("234 Trips"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Trailing Vehicle Icon
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
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16,)
      ],
    );
  }
}
