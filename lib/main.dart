import 'package:flutter/material.dart';
import 'package:kuro_chat/core/config/firebase_options.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize things here
  await initFirebase();
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
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
      initialRoute: AppRouter.home,
    );
  }
}

