import 'package:flutter/material.dart';
import 'package:ryto_customer/app/res/icons.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../styles/app_decorations.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';
import '../../../../widgets/inputs/general_text_field.dart';

enum PaymentOption { none, card, transfer, wallet }
// enum PaymentOption { none, card, transfer }

class PaymentOptionWidget extends StatefulWidget {
  const PaymentOptionWidget({super.key, required this.onSelected});

  final Function(PaymentOption) onSelected;

  @override
  State<PaymentOptionWidget> createState() => _HandlingOptionsCardState();
}

class _HandlingOptionsCardState extends State<PaymentOptionWidget> {
  PaymentOption _selected = PaymentOption.none;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTileWidget(
          svgIcon: AppIcons.debitCard,
          iconHeight: 30,
          border: BoxBorder.all(color: Color(0xffE1E7EF)),
          bgColor: Colors.white,
          title: "Debit/Credit Card",
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          subtitle: "Handle with extra care",
          subTitle: SizedBox(),
          showArrow: false,
          trailing: Radio<PaymentOption>(
            value: PaymentOption.card,
            groupValue: _selected,
            onChanged: (value) {
              setState(() => _selected = value!);
              widget.onSelected(value!);
            },
          ),
        ),
        CustomTileWidget(
          svgIcon: AppIcons.bankTransfer,
          iconHeight: 30,
          border: BoxBorder.all(color: Color(0xffE1E7EF)),
          bgColor: Colors.white,
          title: "Bank Transfer",
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          subTitle: SizedBox(),
          showArrow: false,
          trailing: Radio<PaymentOption>(
            value: PaymentOption.transfer,
            groupValue: _selected,
            onChanged: (value) {
              setState(() => _selected = value!);
              widget.onSelected(value!);
            },
          ),
        ),
        // CustomTileWidget(
        //   svgIcon: AppIcons.wallet,
        //   iconHeight: 30,
        //   border: BoxBorder.all(color: Color(0xffE1E7EF)),
        //   bgColor: Colors.white,
        //   title: "Ryto Wallet",
        //   titleTextStyle: const TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w600,
        //   ),
        //   subtitle: "Balance: ₦12,500",
        //   showArrow: false,
        //   trailing: Radio<PaymentOption>(
        //     value: PaymentOption.wallet,
        //     groupValue: _selected,
        //     onChanged: (value) => setState(() => _selected = value!),
        //   ),
        // ),

        ///Promo code
        // Row(
        //   children: [
        //     Expanded(
        //       child: GeneralTextField(
        //         label: null,
        //         hint: "Enter promo code",
        //         prefixIcon: Icons.shopping_bag_rounded,
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     Container(
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 24,
        //         vertical: 14,
        //       ),
        //       decoration: AppDecoration.roundedOutlinedRadius16
        //           .copyWith(color: const Color(0xffECF3FE)),
        //       child: const Text(
        //         "Apply",
        //         style: TextStyle(
        //           color: Color(0xff0846AA),
        //           fontWeight: FontWeight.w500,
        //           fontSize: 14,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
