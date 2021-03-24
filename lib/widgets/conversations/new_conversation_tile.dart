import 'package:chat_app/helpers/conversation_id_helper.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';

class NewConversationTile extends StatelessWidget {
  final ChatUser contact;
  final String uid;

  const NewConversationTile({Key key, this.contact, this.uid})
      : super(key: key);

  void _createConversation(BuildContext context) {
    String conversationID = ConversationID.getConversationID(uid, contact.id);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => ChatPage(
          uid: uid,
          peer: contact,
          conversationID: conversationID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _createConversation(context),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(contact.imageUrl),
      ),
      title: Text(contact.name),
    );
  }
}
