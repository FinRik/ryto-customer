enum TripType { ride, package }

class Trip {
  final DateTime date;
  final String from;
  final String to;
  final double price;
  final TripType type;

  Trip({
    required this.date,
    required this.from,
    required this.to,
    required this.price,
    required this.type,
  });

  static final List<Trip> mockTrips = [
    // January 2026
    Trip(
      date: DateTime(2026, 1, 27, 12, 56),
      from: 'Lagos',
      to: 'Ibadan',
      price: 18000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2026, 1, 27, 9, 30),
      from: 'Lagos',
      to: 'Ibadan',
      price: 18000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2026, 1, 25, 14, 10),
      from: 'Lagos',
      to: 'Ibadan',
      price: 18000,
      type: TripType.package,
    ),

    // December 2025
    Trip(
      date: DateTime(2025, 12, 20, 16, 45),
      from: 'Lagos',
      to: 'Ibadan',
      price: 18000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2025, 12, 15, 8, 15),
      from: 'Lagos',
      to: 'Ibadan',
      price: 18000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2025, 12, 10, 11, 5),
      from: 'Lagos',
      to: 'Ibadan',
      price: 18000,
      type: TripType.package,
    ),

    // November 2025
    Trip(
      date: DateTime(2025, 11, 28, 18, 20),
      from: 'Abuja',
      to: 'Kaduna',
      price: 25000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2025, 11, 12, 7, 40),
      from: 'Port Harcourt',
      to: 'Owerri',
      price: 15000,
      type: TripType.package,
    ),
  ];

  static final List<Trip> mockUpcomingTrips = [
    // March 2026
    Trip(
      date: DateTime(2026, 3, 18, 9, 00),
      from: 'Lagos',
      to: 'Abuja',
      price: 32000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2026, 3, 25, 14, 30),
      from: 'Ibadan',
      to: 'Ilorin',
      price: 15000,
      type: TripType.package,
    ),

    // April 2026
    Trip(
      date: DateTime(2026, 4, 2, 7, 45),
      from: 'Abuja',
      to: 'Kaduna',
      price: 25000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2026, 4, 10, 16, 20),
      from: 'Port Harcourt',
      to: 'Uyo',
      price: 21000,
      type: TripType.package,
    ),

    // May 2026
    Trip(
      date: DateTime(2026, 5, 5, 12, 10),
      from: 'Lagos',
      to: 'Benin City',
      price: 28000,
      type: TripType.ride,
    ),
  ];

  static final List<Trip> mockPastTrips = [
    // October 2025
    Trip(
      date: DateTime(2025, 10, 22, 13, 15),
      from: 'Lagos',
      to: 'Ibadan',
      price: 18000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2025, 10, 10, 10, 00),
      from: 'Abuja',
      to: 'Jos',
      price: 27000,
      type: TripType.package,
    ),

    // September 2025
    Trip(
      date: DateTime(2025, 9, 14, 8, 25),
      from: 'Enugu',
      to: 'Onitsha',
      price: 14000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2025, 9, 3, 15, 50),
      from: 'Kano',
      to: 'Kaduna',
      price: 23000,
      type: TripType.package,
    ),

    // August 2025
    Trip(
      date: DateTime(2025, 8, 19, 11, 35),
      from: 'Lagos',
      to: 'Abeokuta',
      price: 12000,
      type: TripType.ride,
    ),
    Trip(
      date: DateTime(2025, 8, 2, 17, 05),
      from: 'Port Harcourt',
      to: 'Calabar',
      price: 26000,
      type: TripType.package,
    ),
  ];
}
