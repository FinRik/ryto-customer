import 'package:flutter/material.dart';

import '../../../../../core/models/ui/passenger.dart';

class PassengerTile extends StatelessWidget {
  final Passenger passenger;

  const PassengerTile({
    super.key,
    required this.passenger,
  });

  Color get seatColor {
    if (passenger.status == PassengerStatus.checkedIn) {
      return Colors.blue;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFF3F5F7),
      child: Row(
        children: [
          // Seat Badge
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: seatColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: seatColor, width: 3),
            ),
            child: Text(
              passenger.seat,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: seatColor,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name + Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      passenger.isYou
                          ? 'You (${passenger.name})'
                          : passenger.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    if (passenger.isYou) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'You',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            fontSize: 10
                          ),
                        ),
                      ),
                    ],

                    if (passenger.isDriver) ...[
                      const SizedBox(width: 6),
                      const Text(
                        '(Driver)',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    Icon(
                      passenger.status == PassengerStatus.checkedIn
                          ? Icons.check
                          : Icons.navigation_outlined,
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      passenger.status == PassengerStatus.checkedIn
                          ? 'Checked in'
                          : 'On trip',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Call Button
          if (passenger.canCall)
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_outlined,
                color: Colors.blue,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }
}