import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';

class ChannelListBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChannelListController());
  }
}

class ChannelListController extends GetxController {
  final ChannelRepo _channelRepo = getIt();

  final RxList<ChannelEntity> channels = RxList([]);
  final Rx<LoadState> channelLoadState = Rx<LoadState>(LoadState.none);

  @override
  void onReady() {
    super.onReady();
    _fetchMyChannels();
  }

  void _fetchMyChannels() async {
    channelLoadState(LoadState.loading);
    try {
      final myChannels = await _channelRepo.getMyChannels();
      channels(myChannels);
      channelLoadState(LoadState.success);
    } catch (e) {
      channelLoadState(LoadState.error);
    }
  }
}
