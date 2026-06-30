import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/lat_lng.dart';
import '../../../../core/models/ride/ride.dart';
import '../../../../core/models/ui/package_size.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../../utils/helpers/helpers.dart';
import '../../../blocs/checkout/checkout_bloc.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/inputs/country_phone_input_field.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/scrollable/grid_view_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import 'widgets/handling_options_card.dart';
import 'widgets/package_size_list_item.dart';
import 'widgets/package_content_selector.dart';


class AddPackageDetailScreen extends StatefulWidget {
  const AddPackageDetailScreen({super.key, required this.ride});
  final Ride ride;

  @override
  State<AddPackageDetailScreen> createState() => _AddPackageDetailScreenState();
}

class _AddPackageDetailScreenState extends State<AddPackageDetailScreen> {
  final _recipientNameCtr = TextEditingController();
  final _recipientPhoneCtr = TextEditingController();
  final region = sl<RegionIdentity>();

  String? _selectedPackageSize;
  String? _packageContent;
  String? _weightInput;
  String? _packageDescription;
  List<String> _handlingOptions = [];
  int seats = 1;

  @override
  void dispose() {
    _recipientNameCtr.dispose();
    _recipientPhoneCtr.dispose();
    super.dispose();
  }

  void _calculatePackageEstimate() {
    String? validationError;
    if (_selectedPackageSize == null) {
      validationError = "Please select a package sizing specification.";
    } else if (_packageContent == null || _packageContent!.isEmpty) {
      validationError = "Please describe the contents of the package.";
    } else if (_weightInput == null || _weightInput!.isEmpty) {
      validationError = "Please specify an estimated total weight.";
    } else if (_recipientNameCtr.text.isEmpty) {
      validationError = "Recipient name cannot be left blank.";
    } else if (_recipientPhoneCtr.text.isEmpty) {
      validationError = "Recipient phone contact verification is required.";
    }

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError), backgroundColor: Colors.orange),
      );
      return;
    }

    final packageRequest = BookingRequest(
      tripId: widget.ride.id,
      vehicleId: widget.ride.vehicle?.id,
      seats: seats,
      noBaggage: false,
      packageSize: _selectedPackageSize,
      packageContent: _packageContent,
      packageWeight: Helpers.autoExtractAndRound(_weightInput),
      packageHandlingOptions: _handlingOptions,
      packageRecipientName: _recipientNameCtr.text,
      packageRecipientPhone: _recipientPhoneCtr.text,
      bookingLocation: region.country,
      originLocation: LatLng(lat: widget.ride.originLat, lng: widget.ride.originLng),
      destinationLocation: LatLng(lat: widget.ride.destinationLat, lng: widget.ride.destinationLng),
      pickupLocation: LatLng(lat: widget.ride.pickupLat, lng: widget.ride.pickupLng),
      dropoffLocation: LatLng(lat: widget.ride.dropoffLat, lng: widget.ride.dropoffLng),
    );

    context.read<CheckoutBloc>().add(CalculateCheckoutCost(packageRequest));
  }

  void updateSeats(int value) => setState(() => seats = value);
  void updatePackageSize(PackageSize value) =>
      setState(() => _selectedPackageSize = value.name);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == CheckoutStatus.pricingSuccess && state.costSummary != null) {
          final finalPayload = BookingRequest(
            tripId: widget.ride.id,
            vehicleId: widget.ride.vehicle?.id,
            seats: seats,
            noBaggage: false,
            packageSize: _selectedPackageSize,
            packageContent: _packageContent,
            packageWeight: Helpers.autoExtractAndRound(_weightInput),
            packageHandlingOptions: _handlingOptions,
            packageRecipientName: _recipientNameCtr.text,
            packageRecipientPhone: _recipientPhoneCtr.text,
            bookingLocation: region.country,
            originLocation: LatLng(lat: widget.ride.originLat, lng: widget.ride.originLng),
            destinationLocation: LatLng(lat: widget.ride.destinationLat, lng: widget.ride.destinationLng),
            pickupLocation: LatLng(lat: widget.ride.pickupLat, lng: widget.ride.pickupLng),
            dropoffLocation: LatLng(lat: widget.ride.dropoffLat, lng: widget.ride.dropoffLng),
          );

          context.push(
            Paths.CONFIRMPACKAGEDETAIL,
            extra: TripBookingSummaryArgs(
              ride: widget.ride,
              summary: state.costSummary,
              bookingRequest: finalPayload,
            ),
          );
        } else if (state.status == CheckoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "Calculation error occurred")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == CheckoutStatus.pricingLoading;

        return BaseScaffoldWidget(
          bgColor: const Color(0xffF9F9F9),
          removePadding: true,
          bottomNavBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Button(
              isBusy: isLoading,
              onTap: isLoading ? null : _calculatePackageEstimate,
              text: "Get Estimate",
            ),
          ),
          child: Column(
            children: [
              _buildHeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // CustomCardWidget(
                      //   title: "Select Number of seats",
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       SeatSelectorWidget(onChanged: updateSeats),
                      //       const SizedBox(height: 8),
                      //       const HeaderText(
                      //         label: "Free Cancellation",
                      //         subText: "Cancel up to 24 hours before departure",
                      //         labelStyle: TextStyle(
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 16,
                      //         ),
                      //         subTextStyle: TextStyle(
                      //           fontSize: 13,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //         padding: EdgeInsets.only(bottom: 0),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      CustomCardWidget(
                        title: "Package Size",
                        child: GridViewWidget(
                          list: PackageDetails.packageSizes,
                          physics: NeverScrollableScrollPhysics(),
                          builder: (int index, listItem, isSelected) {
                            return PackageSizeListItem(
                              isItemSelected: isSelected,
                              listItem: listItem!,
                            );
                          },
                          onSelected: updatePackageSize,
                        ),
                      ),
                      CustomCardWidget(
                        title: "What’s Inside?",
                        child: PackageContentSelector(
                          allowed: widget.ride.packagesAllowed ?? true,
                          selectedSize: _packageContent,
                          onSelected: (size) => setState(() => _packageContent = size?.name),
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
                              onChanged: (val) => _recipientPhoneCtr.text = val
                            ),
                          ],
                        ),
                      ),
                      CustomCardWidget(
                        title: "Handling Options",
                        child: HandlingOptionsCard(
                          selectedOptions: _handlingOptions,
                          onChanged: (optionsList) => setState(() => _handlingOptions = optionsList),
                        ),
                      ),
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

  Widget _buildHeaderWidget (){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 24),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
      ),
      child: Row(
        children: [
          BackArrowButton(),
          SizedBox(width: 17),
          Column(
            children: [
              CustomizableHeaderText(
                padding: EdgeInsets.zero,
                label: "Trip Details",
                subTextWidget: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        widget.ride.originCity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff222328),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: Text(" → "),
                    ),
                    SizedBox(
                      width: 110,
                      child: Text(
                        widget.ride.destinationCity,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff222328),
                        ),
                      ),
                    ),
                  ],
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xff222328),
                ),
                subTextStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Color(0xff222328),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}