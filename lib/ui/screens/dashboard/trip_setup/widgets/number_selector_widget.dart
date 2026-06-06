import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/res/icons.dart';
import '../../../../bottom_sheets/passenger_selection_bottom_sheet.dart';


class NumberSelectorWidget extends StatefulWidget {
  const NumberSelectorWidget({super.key});

  @override
  State<NumberSelectorWidget> createState() => _NumberSelectorWidgetState();
}

class _NumberSelectorWidgetState extends State<NumberSelectorWidget> {
  // Local state to track selections from the bottom sheet
  int adults = 1;
  int children = 0;
  int infants = 0;

  void _showPassengerPicker() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PassengerSelectionBottomSheet(
        initialAdults: adults,
        initialChildren: children,
        initialInfants: infants,
        onChanged: (a, c, i) {
          setState(() {
            adults = a;
            children = c;
            infants = i;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate summary text based on selections
    String summary = "$adults Adult${adults > 1 ? 's' : ''}";
    if (children > 0) summary += ", $children Child${children > 1 ? 'ren' : ''}";

    return Column(
      children: [
        SizedBox(height: 4.0),
        GestureDetector(
          onTap: _showPassengerPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: const Color(0xffE5E5E6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppIcons.user),
                    const SizedBox(width: 8),
                  ],
                ),
                Expanded(
                  child: Text(
                    summary,
                    // Forces the text to stay on one line
                    maxLines: 1,
                    // Adds "..." if the text is too long for the available space
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1B2559),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8F9BBA)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}