import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/svgs.dart';
import '../../../../core/models/ui/location_marker.dart';
import '../../../../core/routes/routes.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/buttons/social_sign_in_button.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';

class PackageBookingSummaryScreen extends StatelessWidget {
  const PackageBookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0060EB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 51,
            bottom: 31,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SvgPicture.asset(AppSvgs.package),
                  SizedBox(height: 24),
                  HeaderText(
                    label: "Package Booked",
                    subText: "Your seats have been confirmed",
                    crossAxisAlignment: CrossAxisAlignment.center,
                    titleStyle: TextStyle(color: Color(0xffE3FB20)),
                    subtitleStyle: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 31),
                  Container(
                    decoration: AppDecoration.roundedOutlinedRadius16,
                    padding: EdgeInsets.all(24),
                  ),
                  SizedBox(height: 16),
                  CustomCardWidget(
                    title: "Pickup & Delivery",
                    border: Border.all(width: 0, style: BorderStyle.none),
                    bgColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: LocationMarker.deliveryRoutes
                          .map(
                            (e) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: AppDecoration.roundedOutlinedRadius8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                ],
              ),
              SizedBox(height: 72),
              Column(
                children: [
                  Container(
                    decoration: AppDecoration.roundedOutlinedRadius16.copyWith(
                      color: Color(0xff003A8D),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppSvgs.shieldTick),
                            Column(
                              children: [
                                Text(
                                  "Your safety PIN",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color(0xffF9F9F9),
                                  ),
                                ),
                                Text(
                                  "4729",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 32,
                                    color: Color(0xffE3FB20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Share this PIN with driver when boarding",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xffF9F9F9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ScButton(
                          bgColor: Colors.white,
                          onClick: () {},
                          btnText: "Track Package",
                          btnTextStyle: TextStyle(
                            color: Colors.blue
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SocialSignInButton(
                          onTap: (){},
                          text: "Share",
                          icon: AppIcons.shareOutlined,
                        ),
                      ),
                    ],
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
