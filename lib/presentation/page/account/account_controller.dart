import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/data/auth/repo/auth_repository.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

class AccountController extends GetxController {
  final AuthRepo _authRepo = getIt();

  void logout() async {
    try {
      await _authRepo.logOut();
      Get.offAllNamed(AppRouter.login);
    } catch (e) {
      Get.snackbar('Logout Error', '$e');
    }
  }
}
