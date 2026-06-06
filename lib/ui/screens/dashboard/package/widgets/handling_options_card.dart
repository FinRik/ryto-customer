import 'package:flutter/material.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../widgets/customs/custom_tile_widget.dart';

enum HandlingOption { none, fragile, requireSignature }

class HandlingOptionsCard extends StatefulWidget {
  final Function(List<String>) onChanged; // Changed to return List<String>

  const HandlingOptionsCard({
    super.key,
    required this.onChanged,
  });

  @override
  State<HandlingOptionsCard> createState() => _HandlingOptionsCardState();
}

class _HandlingOptionsCardState extends State<HandlingOptionsCard> {
  // Use a Set for multiple selection (efficient and avoids duplicates)
  final Set<HandlingOption> _selectedOptions = {};

  // Helper to convert enum to string
  String _enumToString(HandlingOption option) {
    switch (option) {
      case HandlingOption.fragile:
        return "FRAGILE";
      case HandlingOption.requireSignature:
        return "REQUIRES_SIGNATURE";
      case HandlingOption.none:
        return "NONE";
    }
  }

  void _onOptionChanged(HandlingOption option, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedOptions.add(option);
      } else {
        _selectedOptions.remove(option);
      }
    });

    // Convert selected options to List<String> and notify parent
    final selectedStrings = _selectedOptions
        .map(_enumToString)
        .toList();

    widget.onChanged(selectedStrings);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTileWidget(
          svgIcon: AppSvgs.location, // TODO: change to proper icon
          title: "Fragile Item",
          titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          subtitle: "Handle with extra care",
          showArrow: false,
          trailing: Checkbox(
            value: _selectedOptions.contains(HandlingOption.fragile),
            onChanged: (bool? checked) {
              _onOptionChanged(HandlingOption.fragile, checked ?? false);
            },
          ),
        ),
        CustomTileWidget(
          svgIcon: AppSvgs.location,
          title: "Require Signature",
          titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          subtitle: "Recipient must sign on delivery",
          showArrow: false,
          trailing: Checkbox(
            value: _selectedOptions.contains(HandlingOption.requireSignature),
            onChanged: (bool? checked) {
              _onOptionChanged(HandlingOption.requireSignature, checked ?? false);
            },
          ),
        ),
      ],
    );
  }
}