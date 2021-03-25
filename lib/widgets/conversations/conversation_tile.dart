import 'package:chat_app/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/chat_user.dart';

// ignore: must_be_immutable
class ConversationTile extends StatelessWidget {
  final ChatUser peer;
  final User user;
  Map<dynamic, dynamic> lastMessage;

  ConversationTile({Key key, this.user, this.peer, this.lastMessage})
      : super(key: key);

  String groupId;
  bool read;

  void updateLastMessage(
      DocumentSnapshot doc, String uid, String pid, String convoID) {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('conversations').doc(convoID);

    documentReference
        .set(<String, dynamic>{
          'lastMessage': <String, dynamic>{
            'idFrom': doc.get('idFrom'),
            'idTo': doc.get('idTo'),
            'timestamp': doc.get('timestamp'),
            'content': doc.get('content'),
            'read': doc.get('read'),
          },
          'users': <String>[uid, pid]
        })
        .then((dynamic success) {})
        .catchError((dynamic error) {
          print(error);
        });
  }

  String getTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    format = dateTime.difference(DateTime.now()).inMilliseconds <= 86400000
        ? DateFormat('jm')
        : DateFormat.yMd('en_US');
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }

  String getGroupChatId() => user.uid.hashCode <= peer.id.hashCode
      ? user.uid + '_' + peer.id
      : peer.id + '_' + user.uid;

  @override
  Widget build(BuildContext context) {
    if (lastMessage['idFrom'] == user.uid) {
      read = true;
    } else {
      read = lastMessage['read'] == null ? true : lastMessage['read'];
    }
    groupId = getGroupChatId();
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (BuildContext context) => ChatPage(
              uid: user.uid,
              peer: peer,
              conversationID: groupId,
            ),
          ),
        )
            .whenComplete(() async {
          if (!read)
            updateLastMessage(
              await FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(groupId)
                  .collection(groupId)
                  .doc(lastMessage['timestamp'])
                  .get(),
              user.uid,
              peer.id,
              groupId,
            );
        });
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(peer.imageUrl),
            child: Visibility(
              visible: !read,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 13.0,
                  width: 13.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              peer.name,
              style: TextStyle(fontWeight: !read ? FontWeight.bold : null),
            ),
          ),
          Text(
            getTime(lastMessage['timestamp']),
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Text(
        lastMessage['content'],
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.fade,
        maxLines: 1,
      ),
    );
  }
}
