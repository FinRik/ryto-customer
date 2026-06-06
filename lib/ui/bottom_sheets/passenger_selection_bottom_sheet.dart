import 'package:flutter/material.dart';

class PassengerSelectionBottomSheet extends StatefulWidget {
  final int initialAdults;
  final int initialChildren;
  final int initialInfants;
  final Function(int, int, int) onChanged;

  const PassengerSelectionBottomSheet({
    super.key,
    this.initialAdults = 1,
    this.initialChildren = 0,
    this.initialInfants = 0,
    required this.onChanged,
  });

  @override
  State<PassengerSelectionBottomSheet> createState() =>
      _PassengerSelectionBottomSheetState();
}

class _PassengerSelectionBottomSheetState
    extends State<PassengerSelectionBottomSheet> {
  late int adults;
  late int children;
  late int infants;

  @override
  void initState() {
    super.initState();
    // Initialize local state with the values passed from the parent
    adults = widget.initialAdults;
    children = widget.initialChildren;
    infants = widget.initialInfants;
  }

  void _update() {
    // Notify the parent widget whenever a value changes
    widget.onChanged(adults, children, infants);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Close Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 24,
                  color: Color(0xFF1B2559),
                ),
              ),
              const Text(
                "Passengers",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1B2559),
                ),
              ),
              const SizedBox(width: 48), // Spacer to center the title
            ],
          ),
          const SizedBox(height: 32),

          // Selection Rows
          _buildCounterRow(
            title: "Adults",
            subtitle: "12+ Years Old",
            count: adults,
            onDecrement: () => setState(() {
              if (adults > 1) adults--;
              _update();
            }),
            onIncrement: () => setState(() {
              adults++;
              _update();
            }),
          ),
          const SizedBox(height: 24),
          _buildCounterRow(
            title: "Children",
            subtitle: "2 - 11 Years Old",
            count: children,
            onDecrement: () => setState(() {
              if (children > 1) children--;
              _update();
            }),
            onIncrement: () => setState(() {
              children++;
              _update();
            }),
          ),
          const SizedBox(height: 24),
          _buildCounterRow(
            title: "Infants on Lap",
            subtitle: "under 2 Years Old",
            count: infants,
            onDecrement: () => setState(() {
              if (infants > 1) infants--;
              _update();
            }),
            onIncrement: () => setState(() {
              infants++;
              _update();
            }),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCounterRow({
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B2559),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8F9BBA),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        // Counter Controls
        Row(
          children: [
            _buildRoundButton(Icons.remove, onDecrement),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
            ),
            _buildRoundButton(Icons.add, onIncrement),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFF0061FF),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
