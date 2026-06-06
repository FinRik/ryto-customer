import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../app/res/icons.dart';
import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/booking/booking_summary.dart';
import '../../../../core/models/payment_meta_data.dart';
import '../../../../core/repos/payment_repo.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/currency_formatter_widget.dart';
import '../../../widgets/inputs/country_phone_input_field.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../trip_setup/widgets/payment_option_widget.dart';
import 'bloc/package_bloc.dart';
import 'widgets/location_detail_card.dart';
import 'widgets/price_breakdown_widget.dart';

class ConfirmPackageSelectScreen extends StatefulWidget {
  const ConfirmPackageSelectScreen({super.key, required this.args});

  final ConfirmPackageSelectArgs args;

  @override
  State<ConfirmPackageSelectScreen> createState() =>
      _ConfirmPackageSelectScreenState();
}

class _ConfirmPackageSelectScreenState
    extends State<ConfirmPackageSelectScreen> {
  PaymentOption? paymentOption;
  bool isChecked = false;

  // Controllers & State Variables
  final _recipientNameCtr = TextEditingController();
  String? _recipientPhoneNumber;

  void updatePaymentOption(PaymentOption value) =>
      setState(() => paymentOption = value);

  @override
  void dispose() {
    _recipientNameCtr.dispose();
    super.dispose();
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _onConfirmAndPay(PaymentMetaData request) async {
    // 1. Validations
    if (_recipientNameCtr.text.trim().isEmpty ||
        _recipientPhoneNumber == null ||
        _recipientPhoneNumber!.trim().isEmpty) {
      _showWarningSnackBar("Please provide recipient details");
      return;
    }

    if (!isChecked) {
      _showWarningSnackBar("Please accept the terms of service");
      return;
    }

    if (paymentOption == null || paymentOption == PaymentOption.none) {
      _showWarningSnackBar("Please select a payment option");
      return;
    }

    // 2. Update Bloc state
    context.read<PackageBloc>().add(
      UpdatePackageProgress(
        BookingRequest(
          packageRecipientName: _recipientNameCtr.text.trim(),
          packageRecipientPhone: _recipientPhoneNumber,
        ),
      ),
    );

    // 3. Initiate payment
    await _makePayment(request);
  }

  Future<void> _makePayment(PaymentMetaData request) async {
    final region = sl<RegionIdentity>();

    // Read repo before the async gap to ensure stability
    final paymentRepo = RepositoryProvider.of<PaymentRepo>(context);

    final result = await paymentRepo.makePayment(
      region.countryCode == "US",
      context,
      request,
    );

    if (!mounted) return;

    if (result) {
      context.read<PackageBloc>().add(BookPackageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    const textDarkColor = Color(0xff222328);

    return BlocConsumer<PackageBloc, PackageState>(
      listener: (context, state) {
        if (state.setupStatus == PackageBookingStatus.success &&
            state.scheduleResponse != null) {
          router.push(Paths.PACKAGEBOOKINGSUMMARY, extra: widget.args.ride);
        }
      },
      builder: (context, state) {
        final summary = state.costSummary;
        final isLoading = state.setupStatus == PackageBookingStatus.loading;

        return Scaffold(
          backgroundColor: const Color(0xffF9F9F9),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // --- Header Row ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      // FIXED: BoxBorder.all changed to Border.all
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
                          // Added Expanded to prevent horizontal overflow
                          child: CustomizableHeaderText(
                            padding: EdgeInsets.zero,
                            label: "Trip Details",
                            subTextWidget: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${widget.args.ride.originCity}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: textDarkColor,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: Text(" → "),
                                ),
                                Expanded(
                                  child: Text(
                                    "${widget.args.ride.destinationCity}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: textDarkColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: textDarkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // --- Content Cards ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        CustomCardWidget(
                          title: "Package Size",
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8.0,
                            ),
                            decoration: AppDecoration.roundedOutlinedRadius8
                                .copyWith(color: const Color(0xff0060EB)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.boxOutlined,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  widget.args.packageSize.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow,
                                  ),
                                ),
                                const Text(
                                  "Documents",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppIcons.timer),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "Estimated Delivery: 2-4 hours",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomCardWidget(
                          title: "Pickup Point",
                          icon: AppIcons.markerPin,
                          child: LocationDetailCard(
                            locationName:
                                state.request.originLocation?.address ??
                                "Main Hub",
                            coord: state.request.pickupLocation!,
                            openingHours: "08:00 AM - 06:00 PM",
                          ),
                        ),
                        CustomCardWidget(
                          title: "Delivery Point",
                          icon: AppIcons.markerPin,
                          iconColor: const Color(0xff889713),
                          child: LocationDetailCard(
                            locationName:
                                state.request.destinationLocation?.address ??
                                "Destination Hub",
                            coord: state.request.dropoffLocation!,
                            openingHours: "09:00 AM - 05:00 PM",
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
                                onChanged: (phone) =>
                                    _recipientPhoneNumber = phone,
                              ),
                            ],
                          ),
                        ),
                        if (summary != null)
                          CustomCardWidget(
                            title: "Price Estimate",
                            child: PriceBreakdownWidget(summary: summary),
                          ),
                        CustomCardWidget(
                          title: "Payment Method",
                          bottomMargin: 24,
                          padding: EdgeInsets.zero,
                          border: Border.all(style: BorderStyle.none),
                          child: PaymentOptionWidget(
                            onSelected: updatePaymentOption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return CurrencyFormatterWidget(
                amount: "${summary?.totalPrice!.formatted}",
                builder: (ctx, formattedAmount, rawAmount) => _buildBottomBar(
                  summary,
                  isLoading,
                  PaymentMetaData(
                    email: "${state.user?.email}",
                    name: "${state.user?.fullname}",
                    tripId: "${widget.args.ride.id}",
                    amount: rawAmount,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(
    BookingSummary? summary,
    bool isLoading,
    PaymentMetaData request,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        height: 140,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (val) => setState(() => isChecked = val ?? false),
                ),
                const Expanded(
                  child: Text(
                    "I agree and accept the terms of service",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CurrencyFormatterWidget(
                  amount: "${summary?.finalPrice?.formatted}",
                  builder: (context, value, rawAmount) => Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Button(
                    isBusy: isLoading,
                    enabled: isChecked,
                    onTap: () => _onConfirmAndPay(request),
                    text: "Confirm & Pay",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
