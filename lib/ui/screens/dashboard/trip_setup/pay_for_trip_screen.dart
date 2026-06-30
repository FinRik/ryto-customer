import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/models/booking/booking_request.dart';
import '../../../../core/models/booking/booking_cost.dart';
import '../../../../core/models/payment_meta_data.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/checkout/checkout_bloc.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/currency_formatter_widget.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../../../widgets/layouts/base_scaffold_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../package/widgets/price_breakdown_widget.dart';
import 'widgets/payment_option_widget.dart';

class PayForTripScreen extends StatefulWidget {
  const PayForTripScreen({super.key, required this.args});
  final TripBookingSummaryArgs args;

  @override
  State<PayForTripScreen> createState() => _PayForTripScreenState();
}

class _PayForTripScreenState extends State<PayForTripScreen> {
  final region = sl<RegionIdentity>();
  PaymentOption? _paymentOption;
  bool _termsAccepted = false;

  void _executePaymentSequence(
    String userFullname,
    String userEmail,
    double rawAmount,
  ) {
    if (_paymentOption == null || _paymentOption == PaymentOption.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Please choose a valid payment processing method"),
        ),
      );
      return;
    }

    // Resolves complete payment details without relying on global state lookups
    final paymentMeta = PaymentMetaData(
      tripId: "${widget.args.ride?.id}",
      name: userFullname,
      email: userEmail,
      amount: rawAmount,
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
        if (state.status == CheckoutStatus.success &&
            state.bookingResponse != null) {
          context.push(
            Paths.TRIPSUMMARY,
            extra: TripBookingSummaryArgs(
              ride: widget.args.ride,
              summary: widget.args.summary,
              bookingResponse: state.bookingResponse,
            ),
          );
        }
      },
      builder: (context, state) {
        final summary = widget.args.summary;
        final request = widget.args.bookingRequest;
        final isBusy = state.status == CheckoutStatus.checkoutLoading;

        return BaseScaffoldWidget(
          removePadding: true,
          bgColor: const Color(0xffF9F9F9),
          bottomNavBar: _buildBottomActionPanel(summary!, isBusy),
          child: Column(
            children: [
              _buildHeaderTitleWidget(request),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(height: 18),
                      CustomCardWidget(
                        title: "Price Estimate",
                        child: PriceBreakdownWidget(
                          summary: summary,
                          isTripBooking: true,
                          seats: request?.seats,
                        ),
                      ),
                      CustomCardWidget(
                        title: "Payment Method",
                        child: PaymentOptionWidget(
                          onSelected: (val) =>
                              setState(() => _paymentOption = val),
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

  Widget _buildBottomActionPanel(BookingCost summary, bool isBusy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
            builder: (context, profileState) {
              final priceText = summary.surgePercentageFormatted != null
                  ? summary.finalPrice!.formatted
                  : summary.totalPrice!.formatted;

              return CurrencyFormatterWidget(
                amount: priceText!,
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
                            : () => _executePaymentSequence(
                                profileState.user!.fullname,
                                profileState.user!.email!,
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

  /// ── HEADER REVIEW & PAY CARD ──────────────────────────────────────────────
  Widget _buildHeaderTitleWidget(BookingRequest? request) {
    final hasPackage =
        request?.packageSize != null && request?.packageSize != "None";
    final seatCount = request?.seats ?? 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffE7E8E9), width: 1)),
      ),
      child: Row(
        children: [
          const BackArrowButton(),
          const SizedBox(width: 16),
          Expanded(
            child: HeaderText(
              padding: EdgeInsets.zero,
              label: "Review & Pay",
              subText:
                  "${widget.args.ride?.originCity} → ${widget.args.ride?.destinationCity}",
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xff002252),
              ),
              subTextStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Color(0xff666E7A),
              ),
            ),
          ),

          // Dynamic metadata tags drawn seamlessly based on the route args parameters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffF4F7FE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasPackage
                      ? Icons.local_shipping_outlined
                      : Icons.airline_seat_recline_normal_rounded,
                  size: 14,
                  color: const Color(0xff0061FF),
                ),
                const SizedBox(width: 4),
                Text(
                  hasPackage
                      ? "Parcel Delivery"
                      : "$seatCount ${seatCount > 1 ? 'Seats' : 'Seat'}",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0061FF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
