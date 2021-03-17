import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/7wJd21GWG5l87CuvJNYg/messages')
            .snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data.docs;
          return snapshot.connectionState == ConnectionState.waiting
              ? Text('loading')
              : ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(docs[index]['text']),
                  ),
                );
        },
      ),
    );
  }
}
