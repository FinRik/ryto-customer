import 'package:cloud_firestore/cloud_firestore.dart';

class TicketChatMessages {
  final String? ticketId; // Null if it's a brand new Live Chat channel initialization
  final String channel;   // e.g., 'Earnings/payout', 'Trip Issues'
  final String title;     // The ticket subject or title

  TicketChatMessages({this.ticketId, required this.channel, required this.title});
}

class ChatMessage {
  final String id;
  final String text;
  final String senderType; // 'user' or 'admin'
  final DateTime timestamp;

  ChatMessage({required this.id, required this.text, required this.senderType, required this.timestamp});

  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String id) {
    return ChatMessage(
      id: id,
      text: data['text'] ?? '',
      senderType: data['senderType'] ?? 'user',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}