import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kuro_chat/core/config/firebase_options.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/presentation/page/home/home_controller.dart';
import 'package:kuro_chat/presentation/page/home/home_page.dart';
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
    return GetMaterialApp(
      title: 'Kuro Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      getPages: AppRouter.getNavigationPages(),
      initialRoute: AppRouter.home,
    );
  }
}
