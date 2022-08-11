import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kuro_chat/core/config/firebase_options.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/data/meta_data/entity/meta_data_entity.dart';
import 'package:kuro_chat/data/meta_data/repository/meta_data_repo.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize things here
  await initFirebase();
  initGetItDi();

  // Run app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MetaDataRepo _metaDataRepo = getIt();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _metaDataRepo.observeMetaData().listen((event) {
        // Do things if needed
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _metaDataRepo.setUserStatus(UserStatus.online);
        break;
      case AppLifecycleState.paused:
        _metaDataRepo.setUserStatus(UserStatus.offline);
        break;
      default:
        return;
    }
  }

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
