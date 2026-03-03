import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../app/res/svgs.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/sc_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/general_text_field.dart';
import '../book_a_trip_screen.dart';
import '../available_trips_screen.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row
        CustomAppBar(),
        const SizedBox(height: 45),
        const Text(
          "Where are you going?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD7F205),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Book a scheduled intercity trip.",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          decoration: AppDecoration.bookingOverlayDeco,
          child: Column(
            children: [
              GeneralTextField(
                label: "Leaving From?",
                hint: "Enter a city, Bustop",
                controller: TextEditingController(),
                prefixSvg: AppSvgs.location,
              ),
              GeneralTextField(
                label: "Going to",
                hint: "Enter Destination",
                controller: TextEditingController(),
                prefixSvg: AppSvgs.location,
              ),
              Row(
                children: [
                  Expanded(
                    child: GeneralTextField(
                      label: null,
                      hint: "25 Dec, 2025",
                      controller: TextEditingController(),
                      prefixSvg: AppIcons.calendar,
                      textInputType: TextInputType.datetime,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Color(0xffE5E5E6)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppIcons.user),
                              SizedBox(width: 8),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              "1 Adult",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ScButton(
                btnText: "Search Trips",
                onClick: () => context.push(Paths.AVAILABLETRIPS),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
