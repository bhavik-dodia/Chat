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
    final isLight = Theme.of(context).brightness == Brightness.light;
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
          return docs.isEmpty
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    bottom: 65.0,
                    top: 5.0,
                    left: 15.0,
                    right: 15.0,
                  ),
                  child:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Expanded(flex: 2, child: buildImage(isLight)),
                                Expanded(flex: 1, child: buildText()),
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
              : ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 7.5,
                    bottom: 65.0,
                    left: 8.0,
                    right: 8.0,
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
                      read: doc['read'],
                      timestamp: doc['timestamp'],
                    );
                  },
                );
        }
      },
    );
  }

  AspectRatio buildImage(bool isLight) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Image.asset(
        'images/chat_${isLight ? 'light' : 'dark'}.png',
      ),
    );
  }

  Container buildText() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: const Text(
        "Let's begin with a 'Hi...'",
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }
}
