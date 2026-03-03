import 'package:flutter/material.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';

enum HandlingOption { none, card, transfer, wallet }

class HandlingPaymentOption extends StatefulWidget {
  const HandlingPaymentOption({super.key});

  @override
  State<HandlingPaymentOption> createState() => _HandlingOptionsCardState();
}

class _HandlingOptionsCardState extends State<HandlingPaymentOption> {
  HandlingOption _selected = HandlingOption.none;

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
          trailing: Radio<HandlingOption>(
            value: HandlingOption.card,
            groupValue: _selected,
            onChanged: (value) => setState(() => _selected = value!),
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
          trailing: Radio<HandlingOption>(
            value: HandlingOption.transfer,
            groupValue: _selected,
            onChanged: (value) => setState(() => _selected = value!),
          ),
        ),
        CustomTileWidget(
          svgIcon: AppSvgs.location,
          border: BoxBorder.all(color: Color(0xffE1E7EF)),
          bgColor: Colors.white,
          title: "Ryto Wallet",
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          subtitle: "Balance: ₦12,500",
          showArrow: false,
          trailing: Radio<HandlingOption>(
            value: HandlingOption.wallet,
            groupValue: _selected,
            onChanged: (value) => setState(() => _selected = value!),
          ),
        ),
      ],
    );
  }
}
