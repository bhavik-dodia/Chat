import 'package:flutter/material.dart';

import '../models/chat_user.dart';
import '../widgets/chat/message_input_bar.dart';
import '../widgets/chat/messages.dart';

class ChatPage extends StatefulWidget {
  final String uid, conversationID;
  final ChatUser peer;

  const ChatPage({Key key, this.uid, this.conversationID, this.peer})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.peer.imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle),
            ),
            Expanded(
              child: Text(
                widget.peer.name,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Messages(uid: widget.uid, conversationID: widget.conversationID),
          Align(
            alignment: Alignment.bottomCenter,
            child: MessageInputBar(
              uid: widget.uid,
              contact: widget.peer,
              convoID: widget.conversationID,
            ),
          ),
        ],
      ),
    );
  }
}
