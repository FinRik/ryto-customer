import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/res/logos.dart';
import '../../../../../app/res/svgs.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/sc_button.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';
import '../../../../widgets/inputs/general_text_field.dart';
import '../../../../widgets/texts/header_text.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              AppLogos.appLogoWhiteYellow,
              height: 24,
              width: 57.89,
            ),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFD7F205),
              ),
              child: const Center(
                child: Text(
                  "DO",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
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
                    child: GestureDetector(
                      onTap: () async {
                        await showDatePickerDialog(
                          context: context,
                          minDate: DateTime(2021, 1, 1),
                          maxDate: DateTime(2023, 12, 31),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffE5E5E6),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.calendar_month),
                            Expanded(
                              child: Text(
                                "25 Dec, 2025",
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
                          Icon(Icons.calendar_month),
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
              ScButton(btnText: "Search Trips", onClick: () async{
                print("object");
                await showDatePickerDialog(
                  context: context,
                  minDate: DateTime(2021, 1, 1),
                  maxDate: DateTime(2023, 12, 31),
                  );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
