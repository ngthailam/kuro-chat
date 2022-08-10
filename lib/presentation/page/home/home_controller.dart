import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/data/auth/repo/auth_repository.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

// https://stackoverflow.com/questions/69805779/getx-oninit-not-calling
class HomeBindings extends Bindings {
  HomeBindings() {
    // Do stuff here
  }

  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

class HomeController extends GetxController {
  final AuthRepo _authRepo = getIt();

  @override
  void onReady() async {
    super.onReady();
    final isLoggedIn = await _authRepo.isLoggedIn();
    if (isLoggedIn) {
      Get.toNamed(AppRouter.channelList);
    } else {
      Get.toNamed(AppRouter.login);
    }
  }
}
