import 'package:flutter/material.dart';
import 'package:sherlock/sherlock.dart';

void main() {
  Sherlock.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                try {
                  throw Exception('Oh no!');
                } catch (e, s) {
                  Sherlock.capture(e, s);
                }
              },
              child: const Text('Manual try catch'),
            ),
            ElevatedButton(
              onPressed: () {
                WidgetsFlutterBinding.ensureInitialized()
                    .platformDispatcher
                    .onError
                    ?.call(Exception('Oh no!'), StackTrace.current);
              },
              child: const Text('PlatformDispatcher.onError'),
            ),
            ElevatedButton(
              onPressed: () {
                FlutterError.reportError(
                  FlutterErrorDetails(
                    exception: Exception('Oh no!'),
                    stack: StackTrace.current,
                  ),
                );
              },
              child: const Text('FlutterError.onError'),
            ),
          ],
        ),
      ),
    );
  }
}
