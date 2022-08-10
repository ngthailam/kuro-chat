import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/auth/repo/auth_repository.dart';

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}

class RegisterController extends GetxController {
  final Rx<LoadState> registerLoadState = Rx<LoadState>(LoadState.none);

  final AuthRepo _authRepo = getIt();

  void registerUser(String text) async {
    try {
      registerLoadState(LoadState.loading);
      await _authRepo.register(text);
      registerLoadState(LoadState.success);
    } catch (e) {
      registerLoadState(LoadState.error);
    }
  }
}
