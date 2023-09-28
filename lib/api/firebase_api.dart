import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:testi/main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print("background");
    print('title ${message.notification?.title}');
    print('body ${message.notification?.body}');
    print('data ${message.data}');
  }
}

class FirebaseApi {
  final _fireBaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      'notif',
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotification() async {
    await _fireBaseMessaging.requestPermission();
    final fcmToken = await _fireBaseMessaging.getToken();
    if (kDebugMode) {
      print("fcmToken : $fcmToken");
    }

    initPushNotifications();
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
