import 'package:flutter/material.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';

// enum PaymentOption { none, card, transfer, wallet }
enum PaymentOption { none, card, transfer }

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
          svgIcon: AppSvgs.location, // change to proper icon
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
          svgIcon: AppSvgs.location,
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
        //   svgIcon: AppSvgs.location,
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
      ],
    );
  }
}
