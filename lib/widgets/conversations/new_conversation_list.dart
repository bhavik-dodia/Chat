import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/chat_user.dart';
import '../../widgets/conversations/new_conversation_tile.dart';

class NewConversationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('New Conversation')),
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .snapshots()
              .map((QuerySnapshot list) => list.docs.map(
                    (DocumentSnapshot snap) {
                      return ChatUser.fromMap(snap.data());
                    },
                  ).toList())
              .handleError((dynamic e) {
            print(e);
          }),
          builder: (context, AsyncSnapshot<List<ChatUser>> snapshot) {
            print(snapshot.data);
            return snapshot.data != null
                ? ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 80.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => Visibility(
                          visible: snapshot.data[index].id != user.uid,
                          child: NewConversationTile(
                            uid: user.uid,
                            contact: snapshot.data[index],
                          ),
                        ),
                    separatorBuilder: (context, index) => Divider())
                : Container();
          }),
    );
  }
}
