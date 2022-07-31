import 'package:flutter/material.dart';
import 'package:kuro_chat/core/config/firebase_options.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize things here
  initFirebase();
  initGetItDi();

  // Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Hello world')),
    );
  }
}
