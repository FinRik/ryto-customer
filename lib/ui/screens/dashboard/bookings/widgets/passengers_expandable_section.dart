import 'package:flutter/material.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../core/models/ride/passenger.dart';
import '../../../../widgets/customs/svg_widget.dart';
import 'passenger_tile.dart';

class PassengersExpandableSection extends StatefulWidget {
  final List<Passenger> passengers;
  // final Driver driver;
  final int passengerCount;

  const PassengersExpandableSection({
    super.key,
    required this.passengers,
    // required this.driver,
    required this.passengerCount,
  });

  @override
  State<PassengersExpandableSection> createState() =>
      _PassengersExpandableSectionState();
}

class _PassengersExpandableSectionState
    extends State<PassengersExpandableSection> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA))),
            ),
            child: Row(
              children: [
                SvgWidget(
                  assetName: AppIcons.users,
                  iconColor: Color(0xff0B64F4),
                  height: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Passengers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 12),

                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff16A249).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.passengers.length}/${widget.passengerCount} on ride',
                    style: const TextStyle(
                      color: Color(0xff16A249),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const Spacer(),

                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isExpanded ? 0.5 : 0,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ],
            ),
          ),
        ),

        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Column(
            children: widget.passengers
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 6,
                      right: 16,
                      left: 16,
                    ),
                    child: PassengerTile(passenger: p),
                  ),
                )
                .toList(),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
