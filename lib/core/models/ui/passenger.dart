enum PassengerStatus {
  onTrip,
  checkedIn,
}

class Passenger {
  final String name;
  final String seat;
  final bool isDriver;
  final bool isYou;
  final PassengerStatus status;
  final bool canCall;

  Passenger({
    required this.name,
    required this.seat,
    this.isDriver = false,
    this.isYou = false,
    required this.status,
    this.canCall = false,
  });


  static List<Passenger> passengers = [
    Passenger(
      name: 'Chidi O.',
      seat: '1A',
      isDriver: true,
      status: PassengerStatus.onTrip,
    ),
    Passenger(
      name: 'John',
      seat: '1B',
      isYou: true,
      status: PassengerStatus.onTrip,
    ),
    Passenger(
      name: 'Sarah D.',
      seat: '2A',
      status: PassengerStatus.onTrip,
      canCall: true,
    ),
    Passenger(
      name: 'Tunde M.',
      seat: '2B',
      status: PassengerStatus.checkedIn,
      canCall: true,
    ),
  ];
}