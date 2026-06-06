import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/user/user_entity.dart';
import '../../core/services/bottom_sheet_service.dart';
import '../blocs/profile/profile_bloc.dart';
import '../screens/chat/bloc/chat_bloc.dart';
import '../screens/chat/widgets/chat_bubble.dart';
import '../widgets/dp_image_widget.dart';
import '../widgets/layouts/base_bottom_sheet.dart';
import '../widgets/loaders/circular_indicator.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the chat as soon as the bottom sheet opens
    // We get tripId and participantIds (driverId) from the request data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(
        InitiateChat(
          tripId: widget.request.data['tripId'],
          participantIds: [widget.request.data['participantId']],
        ),
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<ProfileBloc>().state.user;

    return BaseBottomSheet(
      hasScrollableChild: true,
      multiplier: .9,
      builder: (context, size) {
        return BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            // state.errorMessage
          },
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header displaying the partner's name
                  if (state.conversation != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButton(),
                        CircleAvatar(
                          radius: 16,
                          child: Text(
                            state.conversation!.getChatPartnerInitials(
                              widget.request.data['participantId'],
                            ),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.conversation!.getChatPartnerName(
                                widget.request.data['participantId'],
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              state.conversation!.getChatPartnerRole(
                                widget.request.data['participantId'],
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const Divider(),

                  Expanded(child: _buildMessageList(state, currentUser!)),

                  if (state.status == ChatStatus.success) ...[
                    _buildQuickReplies(context),
                    SizedBox(height: 12),
                    _buildInputArea(context),
                  ],

                  if (state.status == ChatStatus.failure)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(state.errorMessage ?? "Error"),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageList(ChatState state, UserEntity currentUser) {
    if (state.status == ChatStatus.loading) {
      return const Center(child: CircularIndicator());
    }

    // Condition 2: Filter to only show messages between "Me" and the "Target Individual"
    // even if the backend room contains other participants.
    final partnerId = widget.request.data['participantId'];
    final displayMessages = state.filteredMessages(currentUser.id, partnerId);

    if (displayMessages.isEmpty && state.status == ChatStatus.success) {
      return const Center(child: Text("No messages yet."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      reverse: true,
      itemCount: displayMessages.length,
      itemBuilder: (context, index) {
        final message = displayMessages[index];
        final bool isMe = message.sender.id == currentUser.id;
        return ChatBubble(message: message, isMe: isMe);
      },
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: "Type a message...",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  void _handleSend() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(_messageController.text.trim()));
      _messageController.clear();
    }
  }

  Widget _buildQuickReplies(BuildContext context) {
    final replies = ["I'm outside", "Coming now", "Be right there"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => ActionChip(
          label: Text(replies[i], style: const TextStyle(fontSize: 12)),
          onPressed: () =>
              context.read<ChatBloc>().add(SendMessage(replies[i])),
        ),
      ),
    );
  }
}

/// first iteration with bloc logic
//   class ChatBottomSheet extends StatefulWidget {
//   const ChatBottomSheet({
//     super.key,
//     required this.request,
//     required this.completer,
//   });
//
//   final SheetRequest request;
//   final Function(SheetResponse) completer;
//
//   @override
//   State<ChatBottomSheet> createState() => _ChatBottomSheetState();
// }
//
// class _ChatBottomSheetState extends State<ChatBottomSheet> {
//   final _messageController = TextEditingController();
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Access current user once to use in comparisons
//     final currentUser = context.read<ProfileBloc>().state.user;
//
//     return BaseBottomSheet(
//       builder: (context, size) {
//         return BlocBuilder<ChatBloc, ChatState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 // _buildAppBar(state),
//                 Expanded(child: _buildMessageList(state, currentUser!)),
//                 _buildQuickReplies(context),
//                 _buildInputArea(context, state),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildMessageList(ChatState state, UserEntity currentUser) {
//     if (state.status == ChatStatus.loading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (state.status == ChatStatus.error) {
//       return Center(
//         child: Text(state.errorMessage ?? "Error loading messages"),
//       );
//     }
//
//     return ListView.builder(
//       reverse: false, // Set to true if you want the list to start from bottom
//       itemCount: state.messages.length,
//       itemBuilder: (context, index) {
//         final message = state.messages[index];
//         // Compare IDs to determine if the message belongs to the current user
//         final bool isMe = message.sender.id == currentUser.id;
//         return ChatBubble(message: message, isMe: isMe);
//       },
//     );
//   }
//
//   Widget _buildInputArea(BuildContext context, ChatState state) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.grey.shade100,
//             child: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: "Type a message...",
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           FloatingActionButton(
//             onPressed: () {
//               if (_messageController.text.isNotEmpty) {
//                 context.read<ChatBloc>().add(
//                   SendMessage(
//                     conversationId: widget.request.data['conversationId'],
//                     content: _messageController.text,
//                   ),
//                 );
//                 _messageController.clear();
//               }
//             },
//             mini: true,
//             child: const Icon(Icons.send),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Quick replies can dispatch SendMessage directly
//   Widget _buildQuickReplies(BuildContext context) {
//     final replies = ["I have arrived", "Where are you?", "OK"];
//     return SizedBox(
//       height: 50,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: replies
//             .map(
//               (r) => ActionChip(
//                 label: Text(r),
//                 onPressed: () {
//                   context.read<ChatBloc>().add(
//                     SendMessage(
//                       conversationId: widget.request.data['conversationId'],
//                       content: r,
//                     ),
//                   );
//                 },
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }

/// iteration with no data and bloc logic
// class ChatBottomSheet extends StatefulWidget {
//   const ChatBottomSheet({
//     super.key,
//     required this.request,
//     required this.completer,
//   });
//
//   final SheetRequest request;
//   final Function(SheetResponse) completer;
//
//   @override
//   State<ChatBottomSheet> createState() => _ChatBottomSheetState();
// }
//
// class _ChatBottomSheetState extends State<ChatBottomSheet> {
//   final _messageController = TextEditingController();
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }
// @override
//   Widget build(BuildContext context) {
//     return BaseBottomSheet(
//       builder: (context, size) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             title: const ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
//               ),
//               title: Text(
//                 "Adebayo",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 "● Online",
//                 style: TextStyle(color: Colors.green, fontSize: 12),
//               ),
//             ),
//             actions: [
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.call_outlined),
//               ),
//               IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
//             ],
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(40),
//               child: Container(
//                 margin: const EdgeInsets.only(bottom: 8),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   "⇅ LAGOS TO IBADAN",
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) =>
//                       ChatBubble(message: _messages[index]),
//                 ),
//               ),
//               _buildQuickReplies(),
//               _buildInputArea(),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildQuickReplies() {
//     final replies = [
//       "I have arrived",
//       "Where are you?",
//       "Stuck in traffic",
//       "OK",
//     ];
//     return SizedBox(
//       height: 50,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         children: replies
//             .map(
//               (r) => Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ActionChip(label: Text(r), onPressed: () {}),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
//
//   Widget _buildInputArea() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.grey.shade100,
//             child: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Type a message...",
//                 filled: true,
//                 fillColor: Colors.grey.shade100,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           FloatingActionButton(
//             onPressed: () {},
//             mini: true,
//             child: const Icon(Icons.send),
//           ),
//         ],
//       ),
//     );
//   }
// }
