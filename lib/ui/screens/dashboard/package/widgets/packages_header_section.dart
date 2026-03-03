import 'package:flutter/material.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../app/res/svgs.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/sc_button.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/inputs/general_text_field.dart';

class PackagesHeaderSection extends StatelessWidget {
  const PackagesHeaderSection({super.key});

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
              GeneralTextField(
                label: null,
                hint: "25 Dec, 2025",
                controller: TextEditingController(),
                prefixSvg: AppIcons.calendar,
                textInputType: TextInputType.datetime,
              ),
              const SizedBox(height: 24),
              ScButton(btnText: "Proceed", onClick: () {
                router.push(Paths.ADDPACKAGEDETAIL);
              }),
            ],
          ),
        ),
      ],
    );
  }
}
