import 'package:flutter/material.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';
import '../../../../widgets/customs/custom_card_widget.dart';

enum HandlingOption { none, fragile, requireSignature }

class HandlingOptionsCard extends StatefulWidget {
  const HandlingOptionsCard({super.key});

  @override
  State<HandlingOptionsCard> createState() => _HandlingOptionsCardState();
}

class _HandlingOptionsCardState extends State<HandlingOptionsCard> {
  HandlingOption _selected = HandlingOption.none;

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          CustomTileWidget(
            svgIcon: AppSvgs.location, // change to proper icon
            title: "Fragile Item",
            titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            subtitle: "Handle with extra care",
            showArrow: false,
            trailing: Radio<HandlingOption>(
              value: HandlingOption.fragile,
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value!),
            ),
          ),
          CustomTileWidget(
            svgIcon: AppSvgs.location,
            title: "Require Signature",
            titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            subtitle: "Recipient must sign on delivery",
            showArrow: false,
            trailing: Radio<HandlingOption>(
              value: HandlingOption.requireSignature,
              groupValue: _selected,
              onChanged: (value) => setState(() => _selected = value!),
            ),
          ),
        ],
    );
  }
}