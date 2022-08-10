import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/auth/repo/auth_repository.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}

class LoginController extends GetxController {
  final Rx<LoadState> loginLoadState = Rx<LoadState>(LoadState.none);

  final AuthRepo _authRepo = getIt();

  void login(String text) async {
    loginLoadState(LoadState.loading);
    final isLoggedInSuccess = await _authRepo.logIn(text);
    if (isLoggedInSuccess) {
      loginLoadState(LoadState.success);
    } else {
      loginLoadState(LoadState.error);
    }
  }
}
