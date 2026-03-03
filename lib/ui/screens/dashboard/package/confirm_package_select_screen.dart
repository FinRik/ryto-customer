import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/svgs.dart';
import '../../../../core/models/ui/location_marker.dart';
import '../../../../core/models/ui/package_size_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/customs/custom_tile_widget.dart';
import '../../../widgets/inputs/country_input_field.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/scrollable/grid_view_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import 'widgets/handling_options_card.dart';
import 'widgets/package_size_list_item.dart';
import 'widgets/package_sizes_selector.dart';

class ConfirmPackageSelectScreen extends StatefulWidget {
  const ConfirmPackageSelectScreen({super.key, required this.listItem});

  final PackageSizeModel listItem;

  @override
  State<ConfirmPackageSelectScreen> createState() =>
      _ConfirmPackageSelectScreenState();
}

class _ConfirmPackageSelectScreenState
    extends State<ConfirmPackageSelectScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 24),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
                ),
                child: Row(
                  children: [
                    BackArrowButton(),
                    SizedBox(width: 17),
                    Column(
                      children: [
                        HeaderText(
                          padding: EdgeInsets.zero,
                          label: "Delivery Estimate",
                          subText: "Lagos → Ibadan",
                          titleStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff222328),
                          ),
                          subtitleStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xff222328),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    CustomCardWidget(
                      title: "Package Size",
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                        decoration: AppDecoration.roundedOutlinedRadius8.copyWith(color: Color(0xff0060EB)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              AppIcons.boxOutlined,
                              color: Colors.white,
                            ),
                            SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.listItem.catTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow,
                                  ),
                                ),
                                Text(
                                  "Documents",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                SvgPicture.asset(AppIcons.timer),
                                Text(
                                  "Estimated Delivery: 2-4 hours",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomCardWidget(
                      title: "Pickup Point",
                      icon: AppIcons.markerPin,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: LocationMarker.points
                            .map(
                              (e) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration:
                                    AppDecoration.roundedOutlinedRadius8,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      e.location,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      e.address,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${e.openingHrs} - ${e.closingHrs}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xff838794),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    CustomCardWidget(
                      title: "Delivery Point",
                      icon: AppIcons.markerPin,
                      iconColor: Color(0xff889713),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: LocationMarker.points
                            .map(
                              (e) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration:
                                    AppDecoration.roundedOutlinedRadius8,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      e.location,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      e.address,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${e.openingHrs} - ${e.closingHrs}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xff838794),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    CustomCardWidget(
                      title: "Recipient Details",
                      child: Column(
                        children: [
                          GeneralTextField(
                            prefixIcon: null,
                            label: "Recipient Name",
                            hint: "E.g Goerge",
                            controller: TextEditingController(),
                          ),
                          CountryInputField(
                            label: "Phone Number",
                            onChanged: (val) {},
                          ),
                        ],
                      ),
                    ),
                    CustomCardWidget(
                      title: "Price Estimate",
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Base Delivery"),
                              Text(
                                "₦9,000",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0F1729),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Service fee"),
                              Text(
                                "₦500",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0F1729)
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text("₦9,500",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff0B64F4)
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          height: 130,
          color: Color(0xffE7E8E9),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // Optional: give it elevation / shadow if you want the "floating card" look
          // elevation: 8,
          // Optional: change color if needed
          // color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isChecked,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "By checking box  I agree and accept our terms of service",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "₦9,700",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ScButton(onClick: () {
                      context.push(Paths.PACKAGEBOOKINGSUMMARY);
                    }, btnText: "Confirm & Pay"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
