import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/ui/package_size.dart';
import '../../../../core/models/ui/trip_stop.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../../utils/helpers/helpers.dart';
import '../../../blocs/checkout/checkout_bloc.dart';
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
import '../package/widgets/package_content_selector.dart';
import 'widgets/seat_selector_widget.dart';
import 'widgets/trip_stop_timeline_item.dart';

class BookATripScreen extends StatefulWidget {
  const BookATripScreen({super.key, required this.args});
  final BookingDetailsArgs args;

  @override
  State<BookATripScreen> createState() => _BookATripScreenState();
}

class _BookATripScreenState extends State<BookATripScreen> {
  final _recipientNameCtr = TextEditingController();
  final _recipientPhoneCtr = TextEditingController();
  final region = sl<RegionIdentity>();

  String? _selectedPackageSize;
  String? _packageContent;
  String? _weightInput;
  String? _packageDescription;
  List<String>? _handlingOption;
  int _seats = 1;

  bool get hasPackageSelected => _selectedPackageSize != null;

  @override
  void dispose() {
    _recipientNameCtr.dispose();
    _recipientPhoneCtr.dispose();
    super.dispose();
  }

  void _submitFormAndFetchCost() {
    String? validationError;
    if (_selectedPackageSize == null) {
      validationError = "Please select a package size";
    } else if (_packageContent == null || _packageContent!.isEmpty) {
      validationError = "Please specify what is inside the package";
    } else if (_weightInput == null || _weightInput!.isEmpty) {
      validationError = "Please provide an estimated weight";
    } else if (_recipientNameCtr.text.isEmpty) {
      validationError = "Recipient name cannot be left blank.";
    } else if (_recipientPhoneCtr.text.isEmpty) {
      validationError = "Recipient phone contact verification is required.";
    } else if (region.country.isEmpty) {
      validationError = "Unable to process regional identity.";
    }

    if (hasPackageSelected && validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final roundedWeight = Helpers.autoExtractAndRound(_weightInput);

    final bookingPayload = BookingRequest(
      tripId: widget.args.ride.id,
      vehicleId: widget.args.ride.vehicle?.id,
      seats: _seats,
      noBaggage: (hasPackageSelected && _selectedPackageSize != "None")
          ? true
          : false,
      packageSize: _selectedPackageSize,
      packageContent: _packageContent,
      packageWeight: roundedWeight,
      packageHandlingOptions: _handlingOption,
      packageRecipientName: _recipientNameCtr.text,
      packageRecipientPhone: _recipientPhoneCtr.text,
      bookingLocation: region.country,
      originLocation: widget.args.ride.originCoord,
      destinationLocation: widget.args.ride.destCoord,
      pickupLocation: widget.args.pickup,
      dropoffLocation: widget.args.dropOff,
    );

    context.read<CheckoutBloc>().add(CalculateCheckoutCost(bookingPayload));
  }

  void updatePackageSize(PackageSize? size) => setState(() {
    if (size == null || size.name == "None") {
      _selectedPackageSize = null;
      _packageContent = null;
      _weightInput = null;
      _handlingOption = null;
      _recipientNameCtr.clear();
      _recipientPhoneCtr.clear();
    } else {
      _selectedPackageSize = size.name;
    }
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == CheckoutStatus.pricingSuccess &&
            state.costSummary != null) {
          final finalPayload = BookingRequest(
            tripId: widget.args.ride.id,
            vehicleId: widget.args.ride.vehicle?.id,
            seats: _seats,
            noBaggage: (hasPackageSelected && _selectedPackageSize != "None")
                ? true
                : false,
            packageSize: _selectedPackageSize,
            packageContent: _packageContent,
            packageWeight: Helpers.autoExtractAndRound(_weightInput),
            packageHandlingOptions: _handlingOption,
            packageRecipientName: _recipientNameCtr.text,
            packageRecipientPhone: _recipientPhoneCtr.text,
            bookingLocation: region.country,
            originLocation: widget.args.ride.originCoord,
            destinationLocation: widget.args.ride.destCoord,
            pickupLocation: widget.args.pickup,
            dropoffLocation: widget.args.dropOff,
          );

          context.push(
            Paths.PAYFORTRIP,
            extra: TripBookingSummaryArgs(
              ride: widget.args.ride,
              summary: state.costSummary,
              bookingRequest: finalPayload,
            ),
          );
        }
        if (state.status == CheckoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "An error occurred")),
          );
        }
      },
      builder: (context, state) {
        final isBusy = state.status == CheckoutStatus.pricingLoading;

        return BaseScaffoldWidget(
          bgColor: const Color(0xffF9F9F9),
          removePadding: true,
          bottomNavBar: _buildBottomBar(isBusy),
          child: Column(
            children: [
              _buildHeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      _buildTimelineCard(),
                      const SizedBox(height: 29),
                      CustomCardWidget(
                        title: "Select Number of seats",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SeatSelectorWidget(
                              onChanged: (val) => setState(() => _seats = val),
                            ),
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
                      _buildLuggageGrid(),
                      if (hasPackageSelected) _buildPackageFormFields(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(bool isBusy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Button(
        isBusy: isBusy,
        onTap: (isBusy) ? null : _submitFormAndFetchCost,
        text: "Continue",
      ),
    );
  }

  /// ── 1. HEADER ROUTE CARD ──────────────────────────────────────────────────
  Widget _buildHeaderWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffE7E8E9), width: 1),
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
                  "${widget.args.ride.originCity} → ${widget.args.ride.destinationCity}",
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
    );
  }

  /// ── 2. TIMELINE ROUTE TRACKER CARD ────────────────────────────────────────
  Widget _buildTimelineCard() {
    return Column(
      children: [
        ArrivalTimeWidget(
          sourceLat: widget.args.pickup.lat,
          sourceLng: widget.args.pickup.lng,
          destLat: widget.args.dropOff.lat,
          destLng: widget.args.dropOff.lng,
          departureDateTime: widget.args.ride.departureDateTime,
          builder: (cxt, response) => TripStopTimeline(
            duration: response.formattedDuration,
            stops: [
              TripStop(
                location: widget.args.pickup,
                city: widget.args.ride.originCity,
                time: widget.args.ride.departureTime,
                indicatorColor: Colors.blue,
              ),
              TripStop(
                location: widget.args.dropOff,
                city: widget.args.ride.destinationCity,
                time: response.formattedArrivalTime,
                indicatorColor: Colors.green,
                isLast: true,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Divider(height: 1, color: Color(0xffE7E8E9)),
        ),
        DriverScoreCard(
          tripId: widget.args.ride.id,
          vehicle: widget.args.ride.vehicle!,
          driver: widget.args.ride.driver!,
          showTruckCapacity: false,
        ),
      ],
    );
  }

  /// ── 3. LUGGAGE CAPABILITY GRID ────────────────────────────────────────────
  Widget _buildLuggageGrid() {
    return CustomCardWidget(
      title: "Package Size\nAre you sending a package along?",
      border: Border.all(color: const Color(0xffE7E8E9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select 'No Package' if you are traveling with only standard hand luggage, or pick a matching sizing classification option if shipping standalone parcels.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xff666E7A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          GridViewWidget(
            list: PackageDetails.luggageSizes,
            physics: NeverScrollableScrollPhysics(),
            builder: (int index, listItem, isSelected) {
              return PackageSizeListItem(
                isItemSelected: isSelected,
                listItem: listItem!,
              );
            },
            onSelected: updatePackageSize,
          ),
        ],
      ),
    );
  }

  /// ── 4. CONDITIONAL PACKAGE COMPONENT FORM FIELDS ──────────────────────────
  Widget _buildPackageFormFields() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        key: ValueKey<String>(_selectedPackageSize ?? "empty"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            "Package Processing Information",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff002252),
            ),
          ),
          const SizedBox(height: 12),
          CustomCardWidget(
            title: "What’s Inside?",
            border: Border.all(color: const Color(0xffE7E8E9)),
            child: PackageContentSelector(
              allowed: widget.args.ride.packagesAllowed ?? false,
              selectedSize: _packageContent,
              onSelected: (size) {
                setState(() {
                  _packageContent = size?.name;
                });
              },
            ),
          ),
          CustomCardWidget(
            title: "Additional Details",
            child: Column(
              children: [
                GeneralTextField(
                  label: "Estimated Weight (Kg)",
                  hint: "E.g 2.5",
                  prefixIcon: null,
                  onChanged: (val) => _weightInput = val,
                  textInputType: TextInputType.number,
                ),
                GeneralTextField(
                  label: "Description (Optional)",
                  hint: "Describe your package for easy identification",
                  maxLines: 5,
                  borderRadius: 10,
                  prefixIcon: null,
                  textInputType: TextInputType.text,
                  onChanged: (val) => _packageDescription = val,
                ),
              ],
            ),
          ),
          CustomCardWidget(
            title: "Recipient Details",
            child: Column(
              children: [
                GeneralTextField(
                  label: "Recipient Name",
                  hint: "E.g George Jone",
                  prefixIcon: null,
                  controller: _recipientNameCtr,
                ),
                CountryPhoneInputField(
                  onChanged: (val) => _recipientPhoneCtr.text = val,
                ),
              ],
            ),
          ),
          CustomCardWidget(
            title: "Handling Options",
            child: HandlingOptionsCard(
              selectedOptions: _handlingOption ?? [],
              onChanged: (List<String> modernOptions) {
                setState(() {
                  _handlingOption = modernOptions;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
