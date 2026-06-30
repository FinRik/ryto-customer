import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/tickets/ticket_chat_messages.dart';
import '../blocs/profile/profile_bloc.dart';

class SupportChatScreen extends StatefulWidget {
  final TicketChatMessages args;

  const SupportChatScreen({super.key, required this.args});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  late String? _activeTicketId;

  @override
  void initState() {
    super.initState();
    _activeTicketId = widget.args.ticketId;

    // If no ticketId was passed (e.g. user tapped "Live Chat" channel directly),
    // we can lazily create the main ticket document on the first message send.
  }

  Future<void> _sendMessage(String currentUserId) async {
    final String text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();

    final WriteBatch batch = _firestore.batch();

    // 1. If it's a completely new channel session, generate a ticket doc first
    if (_activeTicketId == null) {
      final DocumentReference newTicketRef = _firestore
          .collection('tickets')
          .doc();
      _activeTicketId = newTicketRef.id;

      batch.set(newTicketRef, {
        'ticketId': _activeTicketId,
        'userId': currentUserId,
        'channel': widget.args.channel,
        'subject': widget.args.title,
        'status': 'open',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessageSnippet': text,
      });
    } else {
      // Update existing ticket timestamp and snippet
      final DocumentReference existingTicketRef = _firestore
          .collection('tickets')
          .doc(_activeTicketId);
      batch.update(existingTicketRef, {
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessageSnippet': text,
      });
    }

    // 2. Add message to subcollection
    final DocumentReference newMessageRef = _firestore
        .collection('tickets')
        .doc(_activeTicketId)
        .collection('messages')
        .doc();

    batch.set(newMessageRef, {
      'senderId': currentUserId,
      'senderType': 'user',
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'channelContext': widget.args.channel,
      'ticketTitleContext': widget.args.title,
    });

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.args.title, style: const TextStyle(fontSize: 16)),
            Text(
              widget.args.channel,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: _activeTicketId == null
                  ? const Center(
                      child: Text(
                        "Type a message to start this support thread.",
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('tickets')
                          .doc(_activeTicketId)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final docs = snapshot.data!.docs;

                        return ListView.builder(
                          reverse: true,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final message = ChatMessage.fromFirestore(
                              docs[index].data() as Map<String, dynamic>,
                              docs[index].id,
                            );

                            final bool isMe = message.senderType == 'user';

                            return Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.blue[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(message.text),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Describe your issue details...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage("${state.user?.id}"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
