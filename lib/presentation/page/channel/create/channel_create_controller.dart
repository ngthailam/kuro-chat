import 'package:get/get.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/debouncer.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:kuro_chat/data/user/repo/user_repository.dart';

class ChannelCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChannelCreateController());
  }
}

class ChannelCreateController extends GetxController {
  final ChannelRepo _channelRepo = getIt();
  final UserRepo _userRepo = getIt();

  final Debouncer _searchDebouncer = Debouncer();

  RxList<UserEntity> userSearchResults = <UserEntity>[].obs;
  Rx<LoadState> searchLoadState = Rx<LoadState>(LoadState.none);
  Rx<LoadState> createLoadState = Rx<LoadState>(LoadState.none);

  @override
  void onReady() {
    super.onReady();
    createLoadState.listen((state) {
      if (state == LoadState.success) {
        Get.back();
        return;
      }

      if (state == LoadState.error) {
        Get.snackbar('', 'Create channel error');
        return;
      }
    });
  }

  @override
  void onClose() {
    _searchDebouncer.dispose();
    super.onClose();
  }

  void searchUser(String text) {
    _searchDebouncer.run(() async {
      if (text.isEmpty) {
        searchLoadState(LoadState.success);
        userSearchResults([]);
        return;
      }

      searchLoadState(LoadState.loading);

      try {
        final searchResults = await _userRepo.fetchByName(text);
        searchLoadState(LoadState.success);
        userSearchResults(searchResults);
      } catch (e) {
        searchLoadState(LoadState.error);
      }
    });
  }

  void createChannel(UserEntity receiver) async {
    createLoadState(LoadState.loading);
    try {
      // TODO: needs refactor and rename
      // TODO: add check if channel already exist or smt
      await _channelRepo.createChannel(receiver);
      createLoadState(LoadState.success);
    } catch (e) {
      print('Create channel error $e');
      createLoadState(LoadState.error);
    }
  }
}
