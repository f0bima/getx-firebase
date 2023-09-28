import 'package:flutter/material.dart';
import 'package:testi/api/firebase_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "";

  void generateLink({required String type, required int id}) async {
    await FirebaseApi().createLink(type: type, id: id).then((value) {
      debugPrint("link url: $value");
      setState(() {
        url = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Presss floating action button to generate sample url:',
            ),
            Text(
              url,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                generateLink(type: 'course', id: 1);
              },
              child: const Text("Generate Course Link"),
            ),
            ElevatedButton(
              onPressed: () {
                generateLink(type: 'resume', id: 2);
              },
              child: const Text("Generate Resume Link"),
            ),
          ],
        ),
      ),
    );
  }
}
