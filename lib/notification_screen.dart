import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    String title = message.notification?.title ?? "";
    String body = message.notification?.body ?? "";
    Map<String, dynamic> data = message.data;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("title : $title"),
            Text("body : $body"),
            Text("data: $data"),
          ],
        ),
      ),
    );
  }
}
