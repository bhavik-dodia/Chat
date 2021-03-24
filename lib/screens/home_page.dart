import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/chat_user.dart';
import '../models/conversation.dart';
import '../widgets/conversations/conversation_tile.dart';
import '../widgets/conversations/new_conversation_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _users = FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((QuerySnapshot list) => list.docs
          .map((DocumentSnapshot snap) => ChatUser.fromMap(snap.data()))
          .toList())
      .handleError((dynamic e) {
    print(e);
  });

  final user = FirebaseAuth.instance.currentUser;

  StreamSubscription _usersSub;

  Map<String, ChatUser> userMap = {};

  @override
  void initState() {
    super.initState();
    _usersSub =
        _users.listen((event) => event.forEach((u) => userMap[u.id] = u));
  }

  @override
  void dispose() {
    _usersSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('id', isEqualTo: user.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(child: Icon(Icons.person_rounded)),
                );
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    snapshot.data.docs.single.get('imageUrl'),
                  ),
                ),
              );
            }),
        title: Text(
          'Chats',
          style: GoogleFonts.varelaRound(fontSize: 25.0),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .orderBy('lastMessage.timestamp', descending: true)
            .where('users', arrayContains: user.uid)
            .snapshots()
            .map((QuerySnapshot list) => list.docs
                .map((DocumentSnapshot doc) => Conversation.fromFireStore(doc))
                .toList()),
        builder: (context, snapshot) {
          final conversations = snapshot?.data ?? [];
          return snapshot.connectionState == ConnectionState.waiting
              ? Container()
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 100.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return ConversationTile(
                      user: user,
                      peer: userMap[conversation.userIds[
                          conversation.userIds[0] == user.uid ? 1 : 0]],
                      lastMessage: conversation.lastMessage,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(height: 5.0),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => NewConversationPage(),
          ),
        ),
        child: Icon(Icons.chat_rounded, color: Colors.white,),
      ),
    );
  }
}
