import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/routes.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/texts/header_text.dart';
import 'widgets/handling_payment_option.dart';

class PayForTripScreen extends StatelessWidget {
  const PayForTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        HeaderText(
                          padding: EdgeInsets.zero,
                          label: "Trip Details",
                          subText: "Lagos → Ibadan",
                          titleStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff222328),
                          ),
                          subtitleStyle: TextStyle(
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
              SizedBox(height: 48),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    CustomCardWidget(
                      title: "Price Estimate",
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("2 seat(s) × ₦4,500"),
                              Text(
                                "₦9,000",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0F1729),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Service fee"),
                              Text(
                                "₦500",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0F1729),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Trip protection"),
                              Text(
                                "₦200",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0F1729),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "₦9,700",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff0B64F4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomCardWidget(
                      title: "Price Estimate",
                      bottomMargin: 0,
                      border: Border.all(style: BorderStyle.none),
                      child: HandlingPaymentOption(),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GeneralTextField(
                            label: null,
                            controller: TextEditingController(),
                            hint: "Enter promo code",
                            prefixIcon: Icons.shopping_bag_rounded,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          decoration: AppDecoration.roundedOutlinedRadius16
                              .copyWith(color: Color(0xffECF3FE)),
                          child: Text(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          height: 90,
          color: Color(0xffE7E8E9),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // Optional: give it elevation / shadow if you want the "floating card" look
          // elevation: 8,
          // Optional: change color if needed
          // color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              Expanded(
                child: ScButton(
                  onClick: () {
                    context.push(Paths.TRIPSUMMARY);
                  },
                  btnText: "Confirm ₦9,700",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
