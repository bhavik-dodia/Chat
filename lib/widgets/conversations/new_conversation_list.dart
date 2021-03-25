import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/chat_user.dart';
import '../../widgets/conversations/new_conversation_tile.dart';

class NewConversationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Conversation',
          style: GoogleFonts.varelaRound(fontSize: 20.0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots()
            .map((QuerySnapshot list) => list.docs
                .map((DocumentSnapshot snap) => ChatUser.fromMap(snap.data()))
                .toList())
            .handleError((dynamic e) {
          print(e);
        }),
        builder: (context, AsyncSnapshot<List<ChatUser>> snapshot) {
          print(snapshot.data);
          return snapshot.data != null
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 100.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => Visibility(
                    visible: snapshot.data[index].id != user.uid,
                    child: NewConversationTile(
                      uid: user.uid,
                      contact: snapshot.data[index],
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
