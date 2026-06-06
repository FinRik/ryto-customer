import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/ride/ride.dart';
import '../../../../core/models/ui/package_size.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../utils/helpers/helpers.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/scrollable/grid_view_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../trip_setup/bloc/trip_setup_bloc.dart';
import '../trip_setup/widgets/seat_selector_widget.dart';
import 'bloc/package_bloc.dart';
import 'widgets/handling_options_card.dart';
import 'widgets/package_size_list_item.dart';
import 'widgets/package_sizes_selector.dart';

class AddPackageDetailScreen extends StatefulWidget {
  const AddPackageDetailScreen({super.key, required this.ride});

  final Ride ride;

  @override
  State<AddPackageDetailScreen> createState() => _AddPackageDetailScreenState();
}

class _AddPackageDetailScreenState extends State<AddPackageDetailScreen> {
  PackageSize? _selectedPackageSize;
  String? _selectedContent;
  String? _weightController;
  String? _packageDescription;
  List<String> _handlingOption = [];
  int seats = 1;

  // Update methods
  void updatePackageSize(PackageSize value) =>
      setState(() => _selectedPackageSize = value);
  void updateSelectedContent(String item) =>
      setState(() => _selectedContent = item);
  void updatePackageWeight(String weight) =>
      setState(() => _weightController = weight);
  void updatePackageDescription(String desc) =>
      setState(() => _packageDescription = desc);
  void updateHandlingOption(List<String> items) =>
      setState(() => _handlingOption = items);
  void updateSeats(int value) => setState(() => seats = value);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _resetPackageDependentFields(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onGetEstimate() {
    String? validationError;

    if (_selectedPackageSize == null) {
      validationError = "Please select a package size";
    } else if (_selectedContent == null || _selectedContent!.isEmpty) {
      validationError = "Please specify what is inside the package";
    } else if (_weightController == null || _weightController!.isEmpty) {
      validationError = "Please provide an estimated weight";
    }

    if (validationError != null) {
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

    // 2. Dispatch update and fetch cost
    context.read<PackageBloc>().add(
      UpdatePackageProgress(
        BookingRequest(
          packageSize: _selectedPackageSize?.id,
          packageContent: _selectedContent,
          packageWeight: result,
          packageHandlingOptions: _handlingOption,
          seats: seats,
          // packageDescription: _packageDescription
        ),
      ),
    );

    context.read<PackageBloc>().add(FetchBookingCostRequested());
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackageBloc, PackageState>(
      listener: (context, state) {
        if (state.setupStatus == PackageBookingStatus.success &&
            state.costSummary != null) {
          router.push(
            Paths.CONFIRMPACKAGEDETAIL,
            extra: ConfirmPackageSelectArgs(
              packageSize: _selectedPackageSize!,
              ride: widget.ride,
            ),
          );
        }

        // Handle Failure
        // if (state.setupStatus == PackageBookingStatus.failure) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(state.errorMessage ?? "Failed to get estimate"),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
      },
      child: Scaffold(
        backgroundColor: Color(0xffF9F9F9),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                                    "${widget.ride.originCity}",
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: Text(" → "),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    "${widget.ride.destinationCity}",
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
                ),
                SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
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
                      CustomCardWidget(
                        title: "Package Size",
                        child: GridViewWidget(
                          list: PackageSize.packageSizes,
                          physics: NeverScrollableScrollPhysics(),
                          builder: (int index, listItem, bool isSelected) {
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
                        child: PackageSizesSelector(
                          onChanged: updateSelectedContent,
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
                              onChanged: updatePackageWeight,
                              textInputType: TextInputType.number,
                            ),
                            GeneralTextField(
                              label: "Description (Optional)",
                              hint:
                                  "Describe your package for easy identification",
                              maxLines: 5,
                              borderRadius: 10,
                              prefixIcon: null,
                              onChanged: updatePackageDescription,
                              textInputType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      CustomCardWidget(
                        title: "Handling Options",
                        child: HandlingOptionsCard(
                          onChanged: updateHandlingOption,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomButton(),
      ),
    );
  }

  // Widget _buildBottomButton() {
  //   return BlocBuilder<PackageBloc, PackageState>(
  //     builder: (context, state) {
  //       final isLoading = state is PackageLoading;
  //       return BottomAppBar(
  //         elevation: 8,
  //         child: Button(
  //           isBusy: isLoading,
  //           onTap: _onGetEstimate,
  //           text: "Get Estimate",
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildBottomButton() {
    return BlocBuilder<PackageBloc, PackageState>(
      buildWhen: (prev, curr) => prev.setupStatus != curr.setupStatus,
      builder: (context, state) {
        // Check if the booking/cost setup is currently loading
        final isLoading = state.setupStatus == PackageBookingStatus.loading;

        return BottomAppBar(
          color: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Button(
              isBusy: isLoading,
              // Disable button interaction if loading
              onTap: isLoading ? null : _onGetEstimate,
              text: "Get Estimate",
            ),
          ),
        );
      },
    );
  }
}
