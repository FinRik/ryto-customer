import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../utils/helpers/date_time_helper.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/buttons/button.dart';
import '../../../../widgets/app_bars/custom_app_bar.dart';
import '../../../../widgets/inputs/general_text_field.dart';
import 'number_selector_widget.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final originCity = TextEditingController();
  final destinationCity = TextEditingController();
  final dateCtr = TextEditingController();
  int passengerSeats = 1;

  void _onProceed() {
    final date = DateTimeHelper.parseBackendFormat(dateCtr.text);
    context.push(
      Paths.AVAILABLETRIPS,
      extra: AvailableTripsArgs(
        originCity: originCity.text,
        destinationCity: destinationCity.text,
        departureDate: date,
        passengerSeats: passengerSeats,
        path: Paths.BOOKATRIP,
      ),
    );
  }

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
          "Search trips already created by drivers or book your intercity ride.",
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
                controller: originCity,
                prefixSvg: AppSvgs.location,
                borderRadius: 10,
              ),
              GeneralTextField(
                label: "Going to",
                hint: "Enter Destination",
                controller: destinationCity,
                prefixSvg: AppSvgs.location,
                borderRadius: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GeneralTextField(
                      label: "Departure date",
                      readOnly: true,
                      // hint: "25 Dec, 2025",
                      hint: DateTimeHelper.departureDate,
                      controller: dateCtr,
                      // prefixSvg: AppIcons.calendar,
                      prefixIcon: Icons.calendar_today,
                      // prefixIconSize: 16,
                      textInputType: TextInputType.datetime,
                      borderRadius: 10,
                      isPackageDateSelector: true,
                    ),
                  ),
                  // SizedBox(width: 8),
                  // Expanded(child: NumberSelectorWidget()),
                ],
              ),
              const SizedBox(height: 24),
              Button(text: "Search Trips", onTap: _onProceed),
            ],
          ),
        ),
      ],
    );
  }
}
