import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';

class MessageInputBar extends StatefulWidget {
  final String uid, convoID;
  final ChatUser contact;

  const MessageInputBar({Key key, this.uid, this.convoID, this.contact})
      : super(key: key);

  @override
  _MessageInputBarState createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  String _msg = '';
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    _msgController.clear();
    final content = _msg.trim();
    setState(() => _msg = '');
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final DocumentReference conversationDoc =
        FirebaseFirestore.instance.collection('conversations').doc(widget.convoID);

    conversationDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': widget.uid,
        'idTo': widget.contact.id,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[widget.uid, widget.contact.id]
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('conversations')
          .doc(widget.convoID)
          .collection(widget.convoID)
          .doc(timestamp);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async => transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': widget.uid,
            'idTo': widget.contact.id,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: theme.accentColor,
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.message_rounded,
                    color: Colors.blueAccent,
                  ),
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent[100],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.blueAccent[100]),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                ),
                controller: _msgController,
                onChanged: (value) => setState(() => _msg = value),
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              decoration: BoxDecoration(
                color: theme.accentColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                color: theme.canvasColor,
                icon: Icon(Icons.send_rounded),
                onPressed: _msg.trim().isEmpty ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
