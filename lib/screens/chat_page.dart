import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.peer.imageUrl,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.peer.name,
                style: GoogleFonts.varelaRound(fontSize: 20.0),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
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
