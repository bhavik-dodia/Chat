import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String id;
  List<dynamic> userIds;
  Map<dynamic, dynamic> lastMessage;

  Conversation({this.id, this.userIds, this.lastMessage});

  factory Conversation.fromFireStore(DocumentSnapshot doc) => Conversation(
        id: doc.id,
        userIds: doc?.get('users') ?? <dynamic>[],
        lastMessage: doc?.get('lastMessage') ?? <dynamic>{},
      );
}

class Message {
  String id, content, idFrom, idTo;
  DateTime timestamp;

  Message({this.id, this.content, this.idFrom, this.idTo, this.timestamp});

  factory Message.fromFireStore(DocumentSnapshot doc) => Message(
        id: doc.id,
        content: doc.get('content'),
        idFrom: doc.get('idFrom'),
        idTo: doc.get('idTo'),
        timestamp: doc.get('timestamp'),
      );
}
