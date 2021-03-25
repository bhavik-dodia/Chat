import 'dart:async';

import 'package:chat_app/widgets/profile/update_profile.dart';
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

  _showBottomSheet(QueryDocumentSnapshot snap) => showModalBottomSheet(
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        isScrollControlled: true,
        builder: (context) => UpdateProfile(snap: snap),
      );

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        leading: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(child: Icon(Icons.person_rounded)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () =>
                            _showBottomSheet(snapshot.data.docs.single),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data.docs.single.get('imageUrl'),
                          ),
                        ),
                      ),
                    ),
        ),
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
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator.adaptive();
          else {
            final conversations = snapshot.data;
            return conversations.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    child: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildImage(isLight),
                              const SizedBox(height: 40.0),
                              buildText(),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: buildImage(isLight)),
                              Expanded(child: buildText()),
                            ],
                          ),
                  )
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        tooltip: 'Start new conversation',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => NewConversationPage(),
          ),
        ),
        child: Icon(
          Icons.chat_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  AspectRatio buildImage(bool isLight) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Image.asset(
        'images/conversation_${isLight ? 'light' : 'dark'}.png',
      ),
    );
  }

  Container buildText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: const Text(
        '"Conversation is a catalyst for innnovation." ~John Seely Brown\n\nLet\'s start one, Shall we?',
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }
}
