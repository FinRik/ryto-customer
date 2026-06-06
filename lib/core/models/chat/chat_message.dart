import 'chat_participant.dart';

enum MessageType { TEXT, LOCATION, IMAGE }

class ChatMessage {
  final int id;
  final String content;
  final String messageType;
  final ChatParticipant sender;
  final int? conversationId;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.content,
    required this.messageType,
    required this.sender,
    this.conversationId,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      messageType: json['messageType'] ?? 'TEXT',
      sender: ChatParticipant.fromJson(json['sender']),
      conversationId: json['conversationId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}