import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/ride/passenger.dart';
import '../../../../blocs/profile/profile_bloc.dart';

class PassengerTile extends StatelessWidget {
  final Passenger passenger;

  const PassengerTile({super.key, required this.passenger});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final bool isCurrentUser = state.user?.email == passenger.email;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildSeatBadge(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Display "You" if it's the current user
                        Text(
                          isCurrentUser ? "You" : passenger.fullname,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        // if (passenger.isDriver) ...[
                        //   const SizedBox(width: 6),
                        //   const Text(
                        //     '(Driver)',
                        //     style: TextStyle(fontWeight: FontWeight.w500),
                        //   ),
                        // ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    _buildStatusRow(),
                  ],
                ),
              ),

              // 3. Logic: Only show call button if it's NOT the current user
              // AND the passenger object says they are callable
              // if (!isCurrentUser) _buildCallButton(),
            ],
          ),
        );
      },
    );
  }

  // --- Helper Widgets to keep build clean ---

  Widget _buildSeatBadge() {
    // final color = passenger.status == PassengerStatus.checkedIn
    //     ? Colors.blue
    //     : Colors.green;
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: color.withOpacity(0.15),
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: color, width: 3),
        border: Border.all(color: Colors.green, width: 3),
      ),
      child: Text(
        passenger.firstName!.split(' ').first[0] + passenger.lastName!.split(' ').first[0],
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildCallButton() {
    return GestureDetector(
      onTap: (){
        // CallServiceUtil.makePhoneCall(passenger.pho)
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.phone_outlined, color: Colors.blue, size: 14),
      ),
    );
  }

  Widget _buildStatusRow() {
    // final isCheckedIn = passenger.status == PassengerStatus.checkedIn;
    return Row(
      children: [
        // Icon(isCheckedIn ? Icons.check : Icons.navigation_outlined, size: 12),
        Icon(Icons.navigation_outlined, size: 12),
        const SizedBox(width: 6),
        Text(
          // isCheckedIn ? 'Checked in' : 'On trip',
          'On trip',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

// class PassengerTile extends StatelessWidget {
//   final Passenger passenger;
//
//   const PassengerTile({
//     super.key,
//     required this.passenger,
//   });
//
//   Color get seatColor {
//     if (passenger.status == PassengerStatus.checkedIn) {
//       return Colors.blue;
//     }
//     return Colors.green;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       color: const Color(0xFFF3F5F7),
//       child: Row(
//         children: [
//           // Seat Badge
//           Container(
//             height: 40,
//             width: 40,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: seatColor.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: seatColor, width: 3),
//             ),
//             child: Text(
//               passenger.seat,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: seatColor,
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 12),
//
//           // Name + Status
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       passenger.isYou
//                           ? 'You (${passenger.name})'
//                           : passenger.name,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//
//                     if (passenger.firstName.isYou) ...[
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Text(
//                           'You',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 10
//                           ),
//                         ),
//                       ),
//                     ],
//
//                     if (passenger.isDriver) ...[
//                       const SizedBox(width: 6),
//                       const Text(
//                         '(Driver)',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//
//                 const SizedBox(height: 2),
//
//                 Row(
//                   children: [
//                     Icon(
//                       passenger.status == PassengerStatus.checkedIn
//                           ? Icons.check
//                           : Icons.navigation_outlined,
//                       size: 12,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       passenger.status == PassengerStatus.checkedIn
//                           ? 'Checked in'
//                           : 'On trip_setup',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Call Button
//           if (passenger.canCall)
//             Container(
//               height: 32,
//               width: 32,
//               decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.phone_outlined,
//                 color: Colors.blue,
//                 size: 14,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
