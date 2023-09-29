import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testi/main.dart';
// import 'package:get/get.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) {
    print("background");
    print('title ${message.notification?.title}');
    print('body ${message.notification?.body}');
    print('data ${message.data['id']}');
    print('data ${message.data['parent']}');
  }
}

class FirebaseApi {
  final _fireBaseMessaging = FirebaseMessaging.instance;
  final _fireBaseDeepLink = FirebaseDynamicLinks.instance;

  FirebaseMessaging get firebaseMessaging => _fireBaseMessaging;
  FirebaseDynamicLinks get fireBaseDeepLink => _fireBaseDeepLink;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: "Devisa is used for importance",
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    Map<String, dynamic> data = message.data;
    String parent = data['parent'];
    String id = data['id'];
    navigatorKey.currentState?.pushNamed(
      parent,
      arguments: id,
    );
    // Get.toNamed("/$parent", arguments: id);
  }

  Future initLocalNotifications() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
      handleMessage(message);
    });
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);
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
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotification() async {
    await _fireBaseMessaging.requestPermission();
    final fcmToken = await _fireBaseMessaging.getToken();
    if (kDebugMode) {
      print("fcmToken : $fcmToken");
    }

    initPushNotifications();
    initLocalNotifications();
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initDeepLink() async {
    _fireBaseDeepLink.onLink.listen((event) {
      if (kDebugMode) {
        print("link ${event.link}");
      }
      Map<String, dynamic> parameters = event.link.queryParameters;
      String type = parameters['type'];
      String id = parameters['id'];
      debugPrint("type $type , id $id");
      // Get.toNamed("/$type", arguments: id);
      navigatorKey.currentState?.pushNamed(
        type,
        arguments: id,
      );
    }).onError((error) {
      debugPrint(error.message);
    });
  }

  Future<String> createLink({required String type, required int id}) async {
    String url = 'https://f0bima.com/?type=$type&id=$id';
    String uriPrefix = 'https://f0bimadev.page.link';

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      link: Uri.parse(url),
      uriPrefix: uriPrefix,
      androidParameters: const AndroidParameters(
        packageName: 'com.example.testi',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.testi',
        minimumVersion: "0",
      ),
    );

    final refLink = await _fireBaseDeepLink.buildShortLink(parameters);
    return refLink.shortUrl.toString();
  }
}
