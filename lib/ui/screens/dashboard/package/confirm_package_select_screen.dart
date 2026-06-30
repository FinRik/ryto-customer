import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../app/res/icons.dart';
import '../../../../core/models/payment_meta_data.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/checkout/checkout_bloc.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/currency_formatter_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../trip_setup/widgets/payment_option_widget.dart';
import 'widgets/location_detail_card.dart';
import 'widgets/price_breakdown_widget.dart';

//           bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
//             builder: (context, userState) {
//               return BlocBuilder<PackageBloc, PackageState>(
//                 builder: (ctx, state) {
//                   return CurrencyFormatterWidget(
//                     amount: state.costSummary?.surgePrice != null
//                         ? "${state.costSummary?.finalPrice!.formatted}"
//                         : "${state.costSummary?.totalPrice!.formatted}",
//                     builder: (ctx, formattedAmount, rawAmount) =>
//                         _buildBottomBar(
//                           state.costSummary,
//                           isLoading,
//                           PaymentMetaData(
//                             email: "${userState.user?.email}",
//                             name: "${userState.user?.fullname}",
//                             tripId: "${widget.args.ride.id}",
//                             amount: rawAmount,
//                           ),
//                         ),
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBottomBar(
//     BookingCost? summary,
//     bool isLoading,
//     PaymentMetaData request,
//   ) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(24),
//         topRight: Radius.circular(24),
//       ),
//       child: Container(
//         height: 140,
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Checkbox(
//                   value: isChecked,
//                   onChanged: (val) => setState(() => isChecked = val ?? false),
//                 ),
//                 const Expanded(
//                   child: Text(
//                     "I agree and accept the terms of service",
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 CurrencyFormatterWidget(
//                   amount: "${summary?.finalPrice?.formatted}",
//                   builder: (context, value, rawAmount) => Expanded(
//                     child: Text(
//                       value,
//                       style: const TextStyle(
//                         fontFamily: "Roboto",
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Button(
//                     isBusy: isLoading,
//                     enabled: isChecked,
//                     onTap: () => _onConfirmAndPay(request),
//                     text: "Confirm & Pay",
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ConfirmPackageSelectScreen extends StatefulWidget {
  const ConfirmPackageSelectScreen({super.key, required this.args});
  final TripBookingSummaryArgs args;

  @override
  State<ConfirmPackageSelectScreen> createState() =>
      _KeepPackageConfirmationState();
}

class _KeepPackageConfirmationState extends State<ConfirmPackageSelectScreen> {
  final region = sl<RegionIdentity>();
  PaymentOption? _paymentMethod;
  bool _termsAccepted = false;

  void _processPaymentSequence(
    String fullname,
    String email,
    double finalAmount,
  ) {
    if (_paymentMethod == null || _paymentMethod == PaymentOption.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Please select an active checkout payment processing channel",
          ),
        ),
      );
      return;
    }

    final paymentMeta = PaymentMetaData(
      tripId: "${widget.args.ride?.id}",
      name: fullname,
      email: email,
      amount: finalAmount,
    );

    context.read<CheckoutBloc>().add(
      ConfirmAndPayTrip(
        isRegionUs: region.countryCode == "US",
        paymentMeta: paymentMeta,
        bookingRequest: widget.args.bookingRequest!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        // 1. Primary Success Navigation Route Action
        if (state.status == CheckoutStatus.success && state.bookingResponse != null) {
          context.push(
            Paths.PACKAGEBOOKINGSUMMARY,
            extra: TripBookingSummaryArgs(
              ride: widget.args.ride,
              summary: widget.args.summary,
              bookingResponse: state.bookingResponse,
              bookingRequest: widget.args.bookingRequest,
            ),
          );
        }

        // 2. Primary Failure Action
        if (state.status == CheckoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Checkout operation halted"),
            ),
          );
        }

        // 3. Isolated Background Payment Notification Action (Runs implicitly anywhere)
        if (state.verificationStatus == PaymentVerificationStatus.success ||
            state.verificationStatus == PaymentVerificationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.verificationMessage ?? ""),
              backgroundColor: state.verificationStatus == PaymentVerificationStatus.success
                  ? Colors.green
                  : Colors.amber.shade800,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        const textDarkColor = Color(0xff222328);
        final summary = widget.args.summary;
        final request = widget.args.bookingRequest;
        final isBusy = state.status == CheckoutStatus.checkoutLoading;

        return BaseScaffoldWidget(
          removePadding: true,
          bgColor: const Color(0xffF9F9F9),
          bottomNavBar: _buildBottomActionPanel(isBusy),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE7E8E9), width: 1),
                ),
                child: Row(
                  children: [
                    const BackArrowButton(),
                    const SizedBox(width: 17),
                    Expanded(
                      child: CustomizableHeaderText(
                        padding: EdgeInsets.zero,
                        label: "Trip Details",
                        subTextWidget: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.args.ride!.originCity,
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
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(" → "),
                            ),
                            Expanded(
                              child: Text(
                                widget.args.ride!.destinationCity,
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SvgPicture.asset(
                                  AppIcons.boxOutlined,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "${request!.packageSize}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow,
                                ),
                              ),
                              Text(
                                "${request.packageContent}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Row(
                              //   children: [
                              //     SvgPicture.asset(AppIcons.timer),
                              //     const SizedBox(width: 6),
                              //     const Text(
                              //       "Estimated Delivery: 2-4 hours",
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w700,
                              //         color: Colors.yellow,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                      CustomCardWidget(
                        title: "Pickup Point",
                        icon: AppIcons.markerPin,
                        child: LocationDetailCard(
                          locationName:
                              request.originLocation?.address ?? "Main Hub",
                          coord: request.pickupLocation!,
                          openingHours: "08:00 AM - 06:00 PM",
                        ),
                      ),
                      CustomCardWidget(
                        title: "Delivery Point",
                        icon: AppIcons.markerPin,
                        iconColor: const Color(0xff889713),
                        child: LocationDetailCard(
                          locationName:
                              request.destinationLocation?.address ??
                              "Destination Hub",
                          coord: request.dropoffLocation!,
                          openingHours: "09:00 AM - 05:00 PM",
                        ),
                      ),
                      if (state.costSummary != null)
                        CustomCardWidget(
                          title: "Price Estimate",
                          child: PriceBreakdownWidget(
                            summary: summary!,
                            isTripBooking: false,
                          ),
                        ),
                      CustomCardWidget(
                        title: "Payment Method",
                        child: PaymentOptionWidget(
                          onSelected: (option) =>
                              setState(() => _paymentMethod = option),
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

  Widget _buildBottomActionPanel(bool isBusy) {
    // ClipRRect(
    //     borderRadius: const BorderRadius.only(
    //       topLeft: Radius.circular(24),
    //       topRight: Radius.circular(24),
    //     ),
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            value: _termsAccepted,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "I agree and accept the structural terms of third party logistics delivery service",
              style: TextStyle(fontSize: 12),
            ),
            onChanged: (val) => setState(() => _termsAccepted = val ?? false),
          ),
          const SizedBox(height: 8),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profile) {
              final formattedPrice =
                  (widget.args.summary?.surgePercentageFormatted != null
                      ? widget.args.summary?.finalPrice?.formatted
                      : widget.args.summary?.totalPrice?.formatted) ??
                  "0.0";

              return CurrencyFormatterWidget(
                amount: formattedPrice,
                builder: (context, displayPrice, rawDoubleAmount) => Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayPrice,
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Button(
                        isBusy: isBusy,
                        enabled: _termsAccepted,
                        onTap: (isBusy || !_termsAccepted)
                            ? null
                            : () => _processPaymentSequence(
                                profile.user!.fullname,
                                profile.user!.email!,
                                rawDoubleAmount,
                              ),
                        text: "Confirm & Pay",
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
