import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/chat/message_input_bar.dart';
import '../widgets/chat/messages.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home_rounded),
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
          // PopupMenuButton(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //   ),
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //       value: 'logout',
          //       child: ListTile(
          //         contentPadding: EdgeInsets.zero,
          //         leading: Icon(Icons.exit_to_app_rounded),
          //         title: Text('Logout'),
          //       ),
          //     ),
          //   ],
          //   onSelected: (itemIdentifier) {
          //     if (itemIdentifier == 'logout') FirebaseAuth.instance.signOut();
          //   },
          // ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Messages(),
          Align(
            alignment: Alignment.bottomCenter,
            child: MessageInputBar(),
          ),
        ],
      ),
    );
  }
}
