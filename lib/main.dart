import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testi/api/firebase_api.dart';
import 'package:testi/home_page.dart';
import 'package:testi/course_screen.dart';
import 'package:testi/resume_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  await FirebaseApi().initDeepLink();
  final RemoteMessage? message =
      await FirebaseApi().firebaseMessaging.getInitialMessage();
  final PendingDynamicLinkData? dynamicLink =
      await FirebaseApi().fireBaseDeepLink.getInitialLink();
  runApp(MyApp(
    message: message,
    dynamicLink: dynamicLink,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.message, this.dynamicLink});
  final RemoteMessage? message;
  final PendingDynamicLinkData? dynamicLink;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.message != null) {
        Future.delayed(const Duration(milliseconds: 1000), () async {
          // await Navigator.of(context).pushNamed(...);

          Map<String, dynamic> data = widget.message!.data;
          String parent = data['parent'];
          String id = data['id'];
          navigatorKey.currentState?.pushNamed(
            parent,
            arguments: id,
          );
        });
      }
      if (widget.dynamicLink != null) {
        Future.delayed(const Duration(milliseconds: 1000), () async {
          // await Navigator.of(context).pushNamed(...);

          Map<String, dynamic> parameters =
              widget.dynamicLink!.link.queryParameters;
          String type = parameters['type'];
          String id = parameters['id'];
          debugPrint("type $type , id $id");
          // Get.toNamed("/$type", arguments: id);
          navigatorKey.currentState?.pushNamed(
            type,
            arguments: id,
          );
        });
      }
    });
  }
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MyHomePage(title: 'Flutter Demo Home Page'),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: '/resume',
          page: () => const ResumeScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: '/course',
          page: () => const CourseScreen(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ],
    );
  }
}
