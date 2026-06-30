import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/res/images.dart';
import '../../../../app/res/svgs.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/texts/header_text.dart';

class TripBookingSummaryScreen extends StatelessWidget {
  const TripBookingSummaryScreen({super.key, required this.args});

  final TripBookingSummaryArgs args;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        router.go(Paths.HOME);
      },
      child: Scaffold(
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
                    labelStyle: TextStyle(color: Color(0xffE3FB20)),
                    subTextStyle: TextStyle(color: Colors.white),
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
                                  "${args.bookingResponse?.bookingSafetyPin}",
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
                      Button(
                        buttonColor: Colors.white,
                        onTap: () => router.push(
                          Paths.BOOKINGDETAIL,
                          extra: "${args.ride?.id}",
                        ),
                        text: "View Trip",
                        textColor: Colors.blue,
                      ),
                      SizedBox(height: 12),
                      Button.outline(
                        onTap: () => router.go(Paths.HOME),
                        text: "Go Home",
                        showSuffixIcon: true,
                        icon: Icons.home,
                        textColor: Colors.white,
                        border: Border.all(color: Colors.white),
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
