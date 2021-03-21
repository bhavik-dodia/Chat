import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageInputBar extends StatefulWidget {
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
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chats').add({
      'text': _msg,
      'created on': Timestamp.now(),
      'user id': user.uid,
      'name': userData.get('name'),
      'image url': userData.get('image url'),
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
