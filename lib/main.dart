import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/notifications_helper.dart';
import 'screens/auth_page.dart';
import 'screens/home_page.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      print('in onBackgroundMessage');
  if (message.notification != null) print(message.notification.title);

  // await flutterLocalNotificationsPlugin.show(
  //   0,
  //   message.notification.title + 'from plugin in bg',
  //   message.notification.body,
  //   NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       message.messageId,
  //       'Notification',
  //       'This channel is for notifications',
  //       importance: Importance.max,
  //       priority: Priority.max,
  //     ),
  //   ),
  //   payload: message.data.toString(),
  // );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Notifications.initializeNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chats',
            theme: ThemeData(
              primaryColor: Colors.blueAccent,
              accentColor: Colors.blueAccent,
              textTheme: GoogleFonts.lailaTextTheme(),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.blueAccent,
              accentColor: Colors.blueAccent,
              textTheme: GoogleFonts.lailaTextTheme(
                Theme.of(context).textTheme.apply(
                      bodyColor: Colors.white,
                      displayColor: Colors.white,
                    ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: snapshot.data == null ? AuthPage() : HomePage(),
          );
        });
  }
}
