import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/images.dart';
import '../../../../app/res/svgs.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/buttons/social_sign_in_button.dart';
import '../../../widgets/texts/header_text.dart';

class TripBookingSummaryScreen extends StatelessWidget {
  const TripBookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0060EB),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 51,
          bottom: 31,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(AppImages.car, height: 100),
                SizedBox(height: 24),
                HeaderText(
                  label: "Trip Booked",
                  subText: "Your seats have been confirmed",
                  padding: EdgeInsets.zero,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleStyle: TextStyle(color: Color(0xffE3FB20)),
                  subtitleStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
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
                Column(
                  children: [
                    ScButton(
                      bgColor: Colors.white,
                      onClick: () {},
                      btnText: "View Trip",
                      btnTextStyle: TextStyle(
                          color: Colors.blue
                      ),
                    ),
                    SizedBox(width: 12),
                    SocialSignInButton(
                      onTap: (){},
                      isCenterAligned: true,
                      text: "Share Trip Details",
                      icon: AppIcons.shareOutlined,
                      btnTextStyle: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
