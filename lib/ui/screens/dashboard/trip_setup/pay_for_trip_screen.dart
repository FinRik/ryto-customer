import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
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
import '../../../widgets/customs/custom_card_widget.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/texts/header_text.dart';
import '../package/widgets/price_breakdown_widget.dart';
import 'bloc/trip_setup_bloc.dart';
import 'widgets/payment_option_widget.dart';

class PayForTripScreen extends StatefulWidget {
  const PayForTripScreen({super.key, required this.args});

  final TripBookingSummaryArgs args;

  @override
  State<PayForTripScreen> createState() => _PayForTripScreenState();
}

class _PayForTripScreenState extends State<PayForTripScreen> {
  PaymentOption? paymentOption;

  void updatePaymentOption(PaymentOption value) =>
      setState(() => paymentOption = value);

  Future<void> makePayment(PaymentMetaData request) async {
    final region = sl<RegionIdentity>();
    if (paymentOption == null || paymentOption == PaymentOption.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a payment option"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    final result = await RepositoryProvider.of<PaymentRepo>(
      context,
    ).makePayment(region.countryCode == "US", context, request);
    if (result) {
      context.read<TripSetupBloc>().add(ScheduleTripRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripSetupBloc, TripSetupState>(
      listener: (context, state) {
        if (state.setupStatus == TripSetupStatus.success &&
            state.scheduleResponse != null) {
          router.push(
            Paths.TRIPSUMMARY,
            extra: TripBookingSummaryArgs(
              ride: widget.args.ride,
              summary: widget.args.summary,
              bookingResponse: state.scheduleResponse,
            ),
          );
        }
      },
      builder: (context, state) {
        final summary = widget.args.summary;
        final request = state.request;
        final isBusy = state.setupStatus == TripSetupStatus.loading;

        return Scaffold(
          backgroundColor: const Color(0xffF9F9F9),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(request),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        /// Price Summary Card
                        CustomCardWidget(
                          title: "Price Estimate",
                          child: PriceBreakdownWidget(
                            summary: summary!,
                            isTripBooking: true,
                            seats: request.seats,
                          ),
                        ),

                        /// Payment Option
                        CustomCardWidget(
                          title: "Payment Method",
                          bottomMargin: 24,
                          padding: EdgeInsets.zero,
                          border: Border.all(style: BorderStyle.none),
                          child: PaymentOptionWidget(
                            onSelected: updatePaymentOption,
                          ),
                        ),

                        /// Promo Code
                        Row(
                          children: [
                            Expanded(
                              child: GeneralTextField(
                                label: null,
                                hint: "Enter promo code",
                                prefixIcon: Icons.shopping_bag_rounded,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              decoration: AppDecoration.roundedOutlinedRadius16
                                  .copyWith(color: const Color(0xffECF3FE)),
                              child: const Text(
                                "Apply",
                                style: TextStyle(
                                  color: Color(0xff0846AA),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(summary, isBusy),
        );
      },
    );
  }

  Widget _buildBottomBar(BookingSummary summary, bool isLoading) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (ctx, state) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          height: 100,
          color: const Color(0xffE7E8E9),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Row(
            children: [
              Expanded(
                child: CurrencyFormatterWidget(
                  amount: summary.surgePercentageFormatted != null
                      ? "${summary.finalPrice!.formatted}"
                      : "${summary.totalPrice!.formatted}",
                  builder: (context, value, rawAmount) => Button(
                    isBusy: isLoading,
                    onTap: () => makePayment(
                      PaymentMetaData(
                        tripId: "${widget.args.ride?.id}",
                        name: state.user!.fullname,
                        email: "${state.user!.email}",
                        amount: rawAmount,
                      ),
                    ),
                    isAmount: true,
                    text: "Confirm $value",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BookingRequest request) {
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
          HeaderText(
            padding: EdgeInsets.zero,
            label: "Review & Pay",
            subText:
                "${widget.args.ride?.originCity} → ${widget.args.ride?.destinationCity}",
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
        ],
      ),
    );
  }
}
