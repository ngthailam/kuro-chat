import 'package:get/get.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/debouncer.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';

class ChannelCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChannelCreateController());
  }
}

class ChannelCreateController extends GetxController {
  final ChannelRepo _channelRepo = getIt();

  final Debouncer _searchDebouncer = Debouncer();

  RxList<ChannelEntity> searchResults = <ChannelEntity>[].obs;
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

  void searchChannel(String text) {
    _searchDebouncer.run(() async {
      if (text.isEmpty) {
        searchLoadState(LoadState.success);
        searchResults([]);
        return;
      }

      searchLoadState(LoadState.loading);

      try {
        final result = await _channelRepo.findChannel(text);
        searchLoadState(LoadState.success);
        searchResults(result);
      } catch (e) {
        searchLoadState(LoadState.error);
      }
    });
  }

  void createChannel(ChannelEntity searchResult) {
    createLoadState(LoadState.loading);
    try {
      // TODO: needs refactor and rename
      // TODO: add check if channel already exist or smt
      _channelRepo.createChannel(searchResult.channelId);
      createLoadState(LoadState.success);
    } catch (e) {
      createLoadState(LoadState.error);
    }
  }
}
