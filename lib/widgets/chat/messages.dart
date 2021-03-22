import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('created on', descending: true)
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
            itemBuilder: (context, index) => MessageBubble(
              key: ValueKey(docs[index].id),
              message: docs[index]['text'],
              isSender: uid == docs[index]['user id'],
              imageUrl: docs[index]['image url'],
              name: docs[index]['name'],
            ),
          );
        }
      },
    );
  }
}
