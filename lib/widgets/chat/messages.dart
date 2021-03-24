import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final String conversationID, uid;

  const Messages({Key key, this.conversationID, this.uid}) : super(key: key);

  void _updateMessageRead(DocumentSnapshot doc, String convoID) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('conversations')
        .doc(convoID)
        .collection(convoID)
        .doc(doc.id);

    documentReference.set(
      <String, dynamic>{'read': true},
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationID)
          .collection(conversationID)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else {
          final docs = snapshot.data.docs;
          return ListView.builder(
            reverse: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 75.0,
              horizontal: 8.0,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              if (!doc['read'] && doc['idTo'] == uid)
                _updateMessageRead(doc, conversationID);
              return MessageBubble(
                key: ValueKey(doc.id),
                message: doc['content'],
                isSender: uid == doc['idFrom'],
                read:doc['read'],
                timestamp: doc['timestamp'],
              );
            },
          );
        }
      },
    );
  }
}
