import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class Notifications {
  static void initializeNotifications() async {
    final _messaging = FirebaseMessaging.instance;

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(),
      ),
    );

    _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      criticalAlert: true,
    );

    _messaging.getToken().then((value) => print(value));

    const channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((message) async {
      print('in onMessage');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: android?.smallIcon,
              importance: Importance.max,
              priority: Priority.max,
            ),
          ),
        );
      }

      //     await flutterLocalNotificationsPlugin.show(
      //       0,
      //       message.notification.title + 'from plugin',
      //       message.notification.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           message.messageId,
      //           'Notification',
      //           'This channel is for notifications',
      //           importance: Importance.max,
      //           priority: Priority.max,
      //         ),
      //       ),
      //       payload: message.data.toString(),
      //     );
    });
  }
}
