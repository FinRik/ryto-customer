class RiderNotification {
  final String title;
  final String body;
  // trip_booked, driver_accepted,
  // pin_verified, trip_completed,
  // new_message
  final String type;
  final String? screen;
  final int? tripId;
  final int? bookingId;
  final int? chatId;
  final int? driverId;
  final double? amount;

  RiderNotification({
    required this.title,
    required this.body,
    required this.type,
    this.screen,
    this.tripId,
    this.bookingId,
    this.chatId,
    this.driverId,
    this.amount,
  });

  factory RiderNotification.fromJson(Map<String, dynamic> json) {
    return RiderNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      screen: json['screen'],
      tripId: json['trip_id'] != null ? int.tryParse(json['trip_id'].toString()) : null,
      bookingId: json['booking_id'] != null ? int.tryParse(json['booking_id'].toString()) : null,
      chatId: json['chat_id'] != null ? int.tryParse(json['chat_id'].toString()) : null,
      driverId: json['driver_id'] != null ? int.tryParse(json['driver_id'].toString()) : null,
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
    );
  }
}