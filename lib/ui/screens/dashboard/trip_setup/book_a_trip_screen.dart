import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/lat_lng.dart';
import '../../../../core/models/ride/ride.dart';
import '../../../../core/models/ui/package_size.dart';
import '../../../../core/models/ui/trip_stop.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../utils/helpers/helpers.dart';
import '../../../widgets/arrival_time_widget.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/driver_score_card.dart';
import '../../../widgets/inputs/country_phone_input_field.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/scrollable/grid_view_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../package/widgets/handling_options_card.dart';
import '../package/widgets/package_size_list_item.dart';
import '../package/widgets/package_sizes_selector.dart';
import 'bloc/trip_setup_bloc.dart';
import 'widgets/seat_selector_widget.dart';
import 'widgets/trip_stop_timeline.dart';

class BookATripScreen extends StatefulWidget {
  const BookATripScreen({super.key, required this.ride});

  final Ride ride;

  @override
  State<BookATripScreen> createState() => _BookATripScreenState();
}

class _BookATripScreenState extends State<BookATripScreen> {
  final _recipientNameCtr = TextEditingController();
  String? _recipientPhoneNumber;
  String? _selectedPackageSize;
  String? _selectedContent;
  String? _weightController;
  List<String>? _handlingOption;
  int seats = 1;
  bool isChecked = false;

  bool get hasPackageSelected => _selectedPackageSize != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _resetPackageDependentFields(),
    );
  }

  @override
  void dispose() {
    _recipientNameCtr.dispose();
    super.dispose();
  }

  void _triggerCostFetch() {
    String? validationError;

    if (_selectedPackageSize == null) {
      validationError = "Please select a package size";
    } else if (_selectedContent == null || _selectedContent!.isEmpty) {
      validationError = "Please specify what is inside the package";
    } else if (_weightController == null || _weightController!.isEmpty) {
      validationError = "Please provide an estimated weight";
    } else if (_recipientNameCtr.text.isEmpty) {
      validationError = "Please provide recipient name";
    } else if (_recipientPhoneNumber == null ||
        _recipientPhoneNumber!.isEmpty) {
      validationError = "Please provide recipient phone number";
    }

    // Display error if validation fails
    if (hasPackageSelected && validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = Helpers.autoExtractAndRound(_weightController);

    context.read<TripSetupBloc>().add(
      UpdateTripProgress(
        BookingRequest(
          packageSize: _selectedPackageSize,
          packageContent: _selectedContent,
          packageWeight: result,
          packageHandlingOptions: _handlingOption,
          seats: seats,
          packageRecipientName: _recipientNameCtr.text,
          packageRecipientPhone: _recipientPhoneNumber,
        ),
      ),
    );

    context.read<TripSetupBloc>().add(FetchTripCostRequested());
  }

  void clearSelection() => setState(() => _selectedPackageSize = null);

  void _resetPackageDependentFields() {
    context.read<TripSetupBloc>().add(
      UpdateTripProgress(
        BookingRequest(
          packageSize: null,
          packageHandlingOptions: null,
          packageContent: null,
          packageWeight: null,
          packageRecipientName: null,
          packageRecipientPhone: null,
        ),
      ),
    );
  }

  // Update methods
  void updatePackageSize(PackageSize value) =>
      setState(() => _selectedPackageSize = value.id);
  void updateSelectedContent(String item) =>
      setState(() => _selectedContent = item);
  void updatePackageWeight(String weight) =>
      setState(() => _weightController = weight);
  void updateHandlingOption(List<String> items) =>
      setState(() => _handlingOption = items);
  void updateSeats(int value) => setState(() => seats = value);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripSetupBloc, TripSetupState>(
      listener: (context, state) {
        if (state.setupStatus == TripSetupStatus.success &&
            state.costSummary != null) {
          router.push(
            Paths.PAYFORTRIP,
            extra: TripBookingSummaryArgs(
              ride: widget.ride,
              summary: state.costSummary,
              bookingResponse: null,
            ),
          );
        }
      },
      builder: (context, state) {
        bool isBusy = state.setupStatus == TripSetupStatus.loading;

        return BaseScaffoldWidget(
          bgColor: const Color(0xffF9F9F9),
          removePadding: true,
          bottomNavBar: _buildBottomBar(isBusy),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xffE7E8E9),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const BackArrowButton(),
                      const SizedBox(width: 17),
                      Expanded(
                        child: HeaderText(
                          padding: EdgeInsets.zero,
                          label: "Trip Details",
                          subText:
                              "${widget.ride.originCity} → ${widget.ride.destinationCity}",
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff222328),
                          ),
                          subTextStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xff222328),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      ArrivalTimeWidget(
                        sourceLat: widget.ride.originLat!,
                        sourceLng: widget.ride.originLng!,
                        destLat: widget.ride.destinationLat!,
                        destLng: widget.ride.destinationLng!,
                        departureTime: widget.ride.departureTime!,
                        departureDate: widget.ride.departureDate!,
                        builder: (cxt, response) => TripStopTimeline(
                          duration: response.formattedDuration,
                          stops: [
                            TripStop(
                              location: LatLng(
                                lat: widget.ride.pickupLat!,
                                lng: widget.ride.pickupLng!,
                              ),
                              city: widget.ride.originCity ?? "",
                              time: widget.ride.departureTime ?? "--:--",
                              indicatorColor: Colors.blue,
                            ),
                            TripStop(
                              location: LatLng(
                                lat: widget.ride.dropoffLat!,
                                lng: widget.ride.dropoffLng!,
                              ),
                              city: widget.ride.destinationCity ?? "",
                              time: response.formattedArrivalTime,
                              indicatorColor: Colors.green,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),
                      if (widget.ride.driver != null)
                        DriverScoreCard(
                          driver: widget.ride.driver!,
                          vehicle: widget.ride.vehicle!,
                          tripId: widget.ride.id,
                          showTruckCapacity: true,
                        ),
                      const SizedBox(height: 29),

                      /// Seat Selector
                      CustomCardWidget(
                        title: "Select Number of seats",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SeatSelectorWidget(onChanged: updateSeats),
                            const SizedBox(height: 8),
                            const HeaderText(
                              label: "Free Cancellation",
                              subText: "Cancel up to 24 hours before departure",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              subTextStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              padding: EdgeInsets.only(bottom: 0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Luggage Selector
                      CustomCardWidget(
                        title: "Select your luggage",
                        bottomMargin: 0,
                        child: GridViewWidget(
                          list: PackageSize.luggageSizes,
                          physics: NeverScrollableScrollPhysics(),
                          builder: (index, listItem, isSelected) {
                            return PackageSizeListItem(
                              isItemSelected: isSelected,
                              listItem: listItem!,
                            );
                          },
                          onSelected: updatePackageSize,
                        ),
                      ),

                      if (hasPackageSelected)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF6FEBA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Select a luggage size to see more options",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      if (hasPackageSelected) ...[
                        const SizedBox(height: 15),
                        CustomCardWidget(
                          title: "What’s Inside?",
                          child: PackageSizesSelector(
                            onChanged: updateSelectedContent,
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomCardWidget(
                          title: "Additional Details",
                          child: GeneralTextField(
                            label: "Estimated Weight (Kg)",
                            hint: "E.g 2.5",
                            prefixIcon: null,
                            onChanged: updatePackageWeight,
                            textInputType: TextInputType.number,
                          ),
                        ),
                        CustomCardWidget(
                          title: "Recipient Details",
                          child: Column(
                            children: [
                              GeneralTextField(
                                label: "Recipient Name",
                                hint: "E.g George",
                                prefixIcon: null,
                                controller: _recipientNameCtr,
                              ),
                              CountryPhoneInputField(
                                onChanged: (phone) {
                                  _recipientPhoneNumber = phone;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomCardWidget(
                          title: "Handling Options",
                          child: HandlingOptionsCard(
                            onChanged: updateHandlingOption,
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildBottomBar(String price, bool isLoading) {
  Widget _buildBottomBar(bool isLoading) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffE7E8E9),
        border: Border(top: BorderSide(color: Color(0xffD1D2D4))),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => isChecked = !isChecked),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: const Color(0xff002252),
                  onChanged: (bool? value) =>
                      setState(() => isChecked = value ?? false),
                ),
                const Expanded(
                  child: Text(
                    "By checking box I agree and accept our terms of service",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Button(
            isBusy: isLoading,
            enabled: isChecked,
            onTap: (isLoading || !isChecked) ? null : _triggerCostFetch,
            text: "Continue",
          ),
        ],
      ),
    );
  }
}
