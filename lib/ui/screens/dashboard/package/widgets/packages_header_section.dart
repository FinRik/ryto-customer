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

class PackagesHeaderSection extends StatefulWidget {
  const PackagesHeaderSection({super.key});

  @override
  State<PackagesHeaderSection> createState() => _PackagesHeaderSectionState();
}

class _PackagesHeaderSectionState extends State<PackagesHeaderSection> {
  final _originCity = TextEditingController();
  final _destinationCity = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _originCity.dispose();
    _destinationCity.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onProceed() {
    final date = DateTimeHelper.parseBackendFormat(_dateController.text);
    context.push(
      Paths.AVAILABLETRIPS,
      extra: AvailableTripsArgs(
        originCity: _originCity.text,
        destinationCity: _destinationCity.text,
        departureDate: date,
        path: Paths.ADDPACKAGEDETAIL
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomAppBar(),
        const SizedBox(height: 45),
        const Text(
          "Send a Package",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD7F205),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Find drivers already traveling your route or schedule your package delivery.",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          decoration: AppDecoration.bookingOverlayDeco,
          child: Column(
            children: [
              GeneralTextField(
                label: "Leaving From?",
                hint: "Enter a city, Bustop",
                controller: _originCity,
                prefixSvg: AppSvgs.location,
                borderRadius: 10,
              ),
              GeneralTextField(
                label: "Going to",
                hint: "Enter Destination",
                controller: _destinationCity,
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
                      // hint: "25 Dec, 2025",
                      hint: DateTimeHelper.departureDate,
                      controller: _dateController,
                      // prefixSvg: AppIcons.calendar,
                      // prefixIconSize: 16,
                      prefixIcon: Icons.calendar_today,
                      textInputType: TextInputType.datetime,
                      isPackageDateSelector: true,
                      borderRadius: 10,
                      readOnly: true,
                    ),
                  ),
                  // SizedBox(width: 8),
                  // Expanded(child: NumberSelectorWidget()),
                ],
              ),
              const SizedBox(height: 24),

              Button(text: "Proceed", onTap: _onProceed),
            ],
          ),
        ),
      ],
    );
  }
}
