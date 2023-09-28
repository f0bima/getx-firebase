import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    final id = ModalRoute.of(context)!.settings.arguments as String;

    // String title = message.notification?.title ?? "";
    // String body = message.notification?.body ?? "";
    // Map<String, dynamic> data = message.data;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Course"),
            Text("data: $id"),
          ],
        ),
      ),
    );
  }
}
